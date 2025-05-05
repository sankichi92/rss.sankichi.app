# frozen_string_literal: true

require_relative '../feed'

class HosonoSemi < Feed
  self.title = '細野ゼミ'
  self.description = '細野晴臣が生み出してきた作品やリスナー遍歴を通じてそのキャリアを改めて掘り下げるべく、さまざまなジャンルについて探求する「細野ゼミ」。' \
                     "氏を敬愛してやまない安部勇磨（never young beach）とハマ・オカモト（OKAMOTO'S）という同世代アーティスト2人がゼミ生として参加し、" \
                     '音楽にまつわるさまざまな話題について語り合う。'
  self.link = 'https://natalie.mu/music/serial/76'
  self.language = 'ja'

  def items
    doc.css('main .NA_card a').map do |element|
      date_text = element.at_css('.NA_card_date').content.strip
      date = begin
        Time.strptime(date_text, '%Y年%m月%d日')
      rescue ArgumentError
        Time.strptime(date_text, '%m月%d日')
      end

      Feed::Item.new(
        title: element.at_css('.NA_card_title').content.strip,
        link: element['href'],
        date:,
        description: element.at_css('.NA_card_summary').content.strip,
      )
    end
  end
end
