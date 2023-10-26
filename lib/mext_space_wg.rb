# frozen_string_literal: true

require 'time'

require 'wareki/date'

require_relative 'feed'

class MEXTSpaceWG < Feed
  self.title = '宇宙開発利用部会'
  self.description = '文部科学省 宇宙開発利用部会の最新の配布資料（小委員会含む）'
  self.link = 'https://www.mext.go.jp/b_menu/shingi/gijyutu/gijyutu2/059/index.htm'
  self.language = 'ja'

  def items
    items = []
    items << extract_item(doc)

    doc.css('#contentsMain > p a').each do |sub_wg_anchor|
      sub_wg_doc = Nokogiri::HTML.parse(URI.join(self.class.link, sub_wg_anchor['href']).open)
      items << extract_item(sub_wg_doc)
    end

    items.sort_by(&:date).reverse
  end

  private

  def extract_item(doc)
    link = URI.join(self.class.link, doc.at_xpath("//a[text()='配付資料']")['href'])

    item_doc = Nokogiri::HTML.parse(link.open)

    title = item_doc.at_css('#contentsTitle h1').content
    logger.debug("[#{title}](#{link})")

    description = item_doc.at_css('#contentsMain').dup.tap do |element|
      element.css('.plugin').unlink # removes Adobe Acrobat Reader section
    end.inner_html.strip

    date = Wareki::Date.parse(item_doc.at_css('#contentsMain > p').content.match(/.{2}\d+年\d+月\d+日/)[0]).to_time

    Feed::Item.new(title:, description:, link:, date:)
  end
end
