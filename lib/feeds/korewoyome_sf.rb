# frozen_string_literal: true

require_relative '../feed'

class KorewoyomeSf < Feed
  self.title = '今週はこれを読め！ SF編'
  self.description = 'WEB本の雑誌 > NEWS本の雑誌 > 牧眞司'
  self.link = 'https://www.webdoku.jp/newshz/maki/'
  self.language = 'ja'

  def items
    elements = doc.css('.book')
    elements.map do |e|
      anchor = e.at_css('.catch a')
      Feed::Item.new(
        title: anchor.content.strip,
        description: e.at_css('.excerpt').content.strip,
        link: anchor['href'],
        date: Time.strptime(e.at_css('.date').content.strip, '%Y年%m月%d日%H:%M'),
      )
    end
  end
end
