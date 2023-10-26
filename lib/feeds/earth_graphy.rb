# frozen_string_literal: true

require_relative '../feed'

class EarthGraphy < Feed
  self.title = 'JAXA 第一宇宙技術部門 Earth-graphy'
  self.description = 'Earth-graphyでは、JAXA第一宇宙技術部門の地球観測研究・衛星利用事業・データ提供サービスに関する情報を発信しています。'
  self.link = 'https://earth.jaxa.jp/ja/earthview/index.html'
  self.language = 'ja'

  def items
    doc.css('.search__left .search__content a').map do |anchor|
      Feed::Item.new(
        title: anchor.at_css('.search__ttl').content.strip,
        link: URI.join(self.class.link, anchor['href']),
        date: Time.strptime(anchor.at_css('.search__date').content.strip, '%Y.%m.%d'),
      )
    end
  end
end
