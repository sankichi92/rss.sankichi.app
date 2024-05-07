# frozen_string_literal: true

require 'logger'
require 'net/http'
require 'open-uri'
require 'time'

require 'nokogiri'
require 'rss'
require 'rss/maker/itunes'

class Feed
  class << self
    attr_accessor :title, :description, :link, :language, :itunes_image
  end

  attr_reader :doc, :logger

  def initialize(doc, logger: Logger.new($stdout, progname: self.class.name))
    @doc = doc
    @logger = logger
  end

  def self.build
    html = URI(link).open
    doc = Nokogiri::HTML.parse(html)
    new(doc)
  end

  def items
    raise NotImplementedError
  end

  def to_rss
    RSS::Maker.make('2.0') do |maker|
      maker.channel.title = self.class.title
      maker.channel.description = self.class.description
      maker.channel.link = self.class.link
      maker.channel.language = self.class.language if self.class.language
      maker.channel.itunes_image = self.class.itunes_image if self.class.itunes_image

      items.each do |item|
        new_item = maker.items.new_item
        new_item.title = item.title if item.title
        new_item.description = item.description if item.description
        new_item.link = item.link if item.link
        new_item.date = item.date if item.date

        next unless item.enclosure_url

        enclosure_uri = URI(item.enclosure_url)
        http = Net::HTTP.new(enclosure_uri.host, enclosure_uri.port)
        http.use_ssl = enclosure_uri.scheme == 'https'
        response = http.head(enclosure_uri.path)

        new_item.enclosure.url = item.enclosure_url
        new_item.enclosure.type = response['Content-Type']
        new_item.enclosure.length = response['Content-Length']
      end
    end
  end

  class Item
    attr_reader :title, :description, :link, :date, :enclosure_url

    def initialize(title: nil, description: nil, link: nil, date: nil, enclosure_url: nil)
      raise ArgumentError 'Either title or description is required' if title.nil? && description.nil?

      @title = title
      @description = description
      @link = link
      @date = date
      @enclosure_url = enclosure_url
    end
  end
end
