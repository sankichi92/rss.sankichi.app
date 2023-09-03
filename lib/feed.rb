# frozen_string_literal: true

require 'rss'

class Feed
  class << self
    def title(title = nil)
      if title.nil?
        @title
      else
        @title = title
      end
    end

    def description(description = nil)
      if description.nil?
        @description
      else
        @description = description
      end
    end

    def link(link = nil)
      if link.nil?
        @link
      else
        @link = link
      end
    end

    def language(language = nil)
      if language.nil?
        @language
      else
        @language = language
      end
    end
  end

  def title = self.class.title

  def description = self.class.description

  def link = self.class.link

  def language = self.class.language

  def items
    raise NotImplementedError
  end

  def to_rss
    RSS::Maker.make('2.0') do |maker|
      maker.channel.title = title
      maker.channel.description = description
      maker.channel.link = link
      maker.channel.language = language

      items.each do |item|
        new_item = maker.items.new_item
        new_item.title = item.title
        new_item.description = item.description
        new_item.link = item.link
        new_item.date = item.date
      end
    end
  end

  class Item
    attr_reader :title, :description, :link, :date

    def initialize(title: nil, description: nil, link: nil, date: nil)
      @title = title
      @description = description
      @link = link
      @date = date
    end
  end
end
