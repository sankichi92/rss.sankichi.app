# frozen_string_literal: true

require 'open-uri'
require 'time'

require 'nokogiri'

require_relative 'feed'

class CAOSpacePolicy < Feed
  title '内閣府 宇宙政策'
  description '内閣府 宇宙政策 最近のトピックス'
  link 'https://www8.cao.go.jp/space/index.html'
  language 'ja'

  attr_reader :doc

  def initialize(html: URI(link).open)
    @doc = Nokogiri::HTML.parse(html)
  end

  def items
    doc.css('#mainContents .topicsList').map do |topic_element| # 最近のトピックス
      title_anchor = topic_element.at_css('dd a').dup
      title_anchor.css('span').unlink # remove the "New!" label

      Item.new(
        link: URI.join(link, title_anchor.attribute('href').value.strip).to_s,
        title: title_anchor.content,
        date: Time.strptime(topic_element.at_css('dt').content, '%Y年%m月%d日'),
      )
    end
  end

  class Item < Feed::Item
    attr_reader :doc

    def initialize(title:, link:, date:, html: URI(link).open)
      super(title:, link:, date:)
      @doc = Nokogiri::HTML.parse(html)
    end

    def description
      return if link == 'https://www8.cao.go.jp/space/minister/danwa.html' # no item-specific content on this page

      main_contents = doc.at_css('#mainContents').dup
      main_contents.css('.pageTop').unlink
      main_contents.inner_html.strip
    end
  end
end
