# frozen_string_literal: true

require 'open-uri'
require 'time'

require 'nokogiri'

require_relative 'feed'

class MadeInAbyss < Feed
  self.title = 'メイドインアビス'
  self.description = 'WEBコミックガンマ メイドインアビス 最新話'
  self.link = 'https://webcomicgamma.takeshobo.co.jp/manga/madeinabyss/'
  self.language = 'ja'

  attr_reader :doc

  def initialize(html: URI(self.class.link).open)
    super()
    @doc = Nokogiri::HTML.parse(html)
  end

  def items
    anchor = doc.at_css('.read__area a')
    [
      Feed::Item.new(
        title: anchor.at_css('.episode').content.strip,
        link: URI.join(self.class.link, anchor['href']),
        date: Time.strptime(anchor.at_css('.episode__text').content, '%Y年%m月%d日'),
      ),
    ]
  end
end
