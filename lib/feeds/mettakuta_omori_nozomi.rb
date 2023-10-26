# frozen_string_literal: true

require_relative '../feed'

class MettakutaOmoriNozomi < Feed
  self.title = '新刊めったくたガイド: 大森望'
  self.description = 'WEB本の雑誌 > 新刊めったくたガイド > 大森望'
  self.link = 'https://www.webdoku.jp/mettakuta/omori_nozomi/'
  self.language = 'ja'

  def items
    anchors = doc.css('.entry-content a')
    anchors.map do |anchor|
      Feed::Item.new(
        title: anchor.at_css('h3').content.strip,
        link: anchor['href'],
        date: Time.strptime(anchor.at_css('.date').content.strip, '%Y年%m月号'),
      )
    end
  end
end
