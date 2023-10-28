# frozen_string_literal: true

require_relative '../feed'

class KemurNojiriH < Feed
  self.title = '野尻抱介の「ぱられる・シンギュラリティ」'
  self.description = 'SF小説家・野尻抱介氏が、原始的な遊びを通して人類のテクノロジー史を辿り直す'
  self.link = 'https://kemur.jp/tag/%e9%87%8e%e5%b0%bb%e6%8a%b1%e4%bb%8b'
  self.language = 'ja'

  def items
    doc.css('.archive .archive__contents').map do |element|
      anchor = element.at_css('.heading a')
      Feed::Item.new(
        title: anchor.content.strip,
        link: anchor['href'],
        date: Time.strptime(element.at_css('.dateList__item').content.strip, '%Y年%m月%d日'),
      )
    end
  end
end
