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
    doc.css('#content_tab_voice .box-article-item a').map do |anchor|
      sub_doc = Nokogiri::HTML.parse(URI(anchor['href']).open)
      json_ld = JSON.parse(sub_doc.xpath("(//script[@type='application/ld+json'])[2]").text.strip)

      Feed::Item.new(
        title: anchor.at_css('p').content.strip,
        description: sub_doc.at_css('.txt-detail').content.strip,
        link: anchor['href'],
        date: Time.parse(json_ld[0]['datePublished']),
        enclosure_url: json_ld[0]['audio'][0]['contentUrl'],
        itunes_duration: ActiveSupport::Duration.parse(json_ld[0]['audio'][0]['duration']).to_i.to_s,
      )
    end
  end
end
