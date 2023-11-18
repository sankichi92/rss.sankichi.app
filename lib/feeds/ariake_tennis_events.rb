# frozen_string_literal: true

require 'wareki/date'

require_relative '../feed'

class AriakeTennisEvents < Feed
  self.title = '有明テニスの森公園イベント'
  self.description = '有明テニスの森公園のイベント一覧'
  self.link = 'https://www.tptc.co.jp/park/02_03/event'
  self.language = 'ja'

  def items
    doc.css('#mainbody .info-box').map do |element|
      anchor = element.at_css('h3 a')
      Feed::Item.new(
        title: anchor.content.strip,
        link: anchor['href'],
        date: Wareki::Date.parse(element.at_css('.date p').content.match(/.{2}\d+年\d+月\d+日/)[0]).to_time,
        description: element.at_css('.cont-txt p').content.strip,
      )
    end
  end
end
