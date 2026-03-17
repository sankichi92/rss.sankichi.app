# frozen_string_literal: true

require_relative '../feed'

class CaoSpacePolicy < Feed
  self.title = '内閣府 宇宙政策'
  self.description = '内閣府 宇宙政策 最近のトピックス'
  self.link = 'https://www8.cao.go.jp/space/index.html'
  self.language = 'ja'

  def items
    doc.css('#mainContents .topicsList').map do |topic_element| # 最近のトピックス
      title_anchor = topic_element.at_css('dd a').dup
      title_anchor.css('span').unlink # removes the "New!" label
      title = title_anchor.content

      link = URI.join(self.class.link, title_anchor['href'].strip)
      logger.debug("[#{title}](#{link})")

      description = extract_item_description(link)
      date = Time.strptime(topic_element.at_css('dt').content, '%Y年%m月%d日')

      Feed::Item.new(title:, description:, link:, date:)
    end
  end

  private

  def extract_item_description(link)
    item_response = link.open
    return nil unless item_response.content_type == 'text/html'

    extract_main_contents(item_response.read)
  end

  def extract_main_contents(sub_page_html)
    item_doc = Nokogiri::HTML.parse(sub_page_html)
    main_contents = item_doc.at_css('#mainContents')
    return nil unless main_contents

    main_contents = main_contents.dup
    main_contents.css('.pageTop').unlink # removes "このページの先頭へ"
    main_contents.inner_html.strip
  end
end
