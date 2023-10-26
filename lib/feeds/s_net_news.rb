# frozen_string_literal: true

require 'json'

require_relative '../feed'

class SNetNews < Feed
  self.title = 'S-NET NEWS'
  self.description = '宇宙に関する話題をピックアップ'
  self.link = 'https://s-net.space/news'
  self.language = 'ja'

  def self.build
    body = URI("#{link}/get-data").read
    json = JSON.parse(body)
    doc = Nokogiri::HTML.parse(json['html'])
    new(doc)
  end

  def items
    doc.css('li').map do |element|
      anchor = element.at_css('a')
      Feed::Item.new(
        title: anchor.content.strip,
        link: anchor['href'],
        date: Time.strptime(element.at_css('.date strong').content.strip, '%Y.%m.%d'),
      )
    end
  end
end
