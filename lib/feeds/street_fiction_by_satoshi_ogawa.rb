# frozen_string_literal: true

require 'json'

require 'active_support'
require 'active_support/duration'

require_relative '../feed'

class StreetFictionBySatoshiOgawa < Feed
  self.title = 'Street Fiction by SATOSHI OGAWA'
  self.description = '『地図と拳』で直木賞を受賞、今注目を集める気鋭の小説家 小川哲。リベラルアーツをコンセプトに、毎週日曜の朝にゲストを迎えた対談、' \
                     '本の音声レビュー、シンポジウムやイベント等のレポートなど、番組を通じ様々な気づきをお届けしていきます。'
  self.link = 'https://audee.jp/program/show/300005062'
  self.language = 'ja'
  self.itunes_image = 'https://pms-next-prod-api-program.s3.ap-northeast-1.amazonaws.com/image/pglogo/6305868d-37a2-421d-8ce4-4d32154d9853_au_large.jpg'

  def items
    doc.css('#content_tab_voice .box-article-item a').flat_map do |anchor|
      sub_doc = Nokogiri::HTML.parse(URI(anchor['href']).open)
      json_ld = JSON.parse(sub_doc.xpath("(//script[@type='application/ld+json'])[2]").text.strip)
      podcast_episode = json_ld.find { |obj| obj['@type'] == 'PodcastEpisode' }

      if podcast_episode['audio'].size == 1
        Feed::Item.new(
          title: podcast_episode['name'].split(' | ').first,
          description: Nokogiri::HTML.parse(podcast_episode['description']).text.strip,
          link: podcast_episode['url'],
          date: Time.parse(podcast_episode['partOfSeries']['datePublished']),
          enclosure_url: podcast_episode['audio'][0]['contentUrl'],
          itunes_duration: ActiveSupport::Duration.parse(podcast_episode['audio'][0]['duration']).to_i.to_s,
        )
      else
        podcast_episode['audio'].map do |audio|
          Feed::Item.new(
            title: [audio['name'], audio['description']].join(' '),
            description: Nokogiri::HTML.parse(podcast_episode['description']).text.strip,
            link: podcast_episode['url'],
            date: Time.parse(audio['uploadDate']),
            enclosure_url: audio['contentUrl'],
            itunes_duration: ActiveSupport::Duration.parse(audio['duration']).to_i.to_s,
          )
        end
      end
    end
  end
end
