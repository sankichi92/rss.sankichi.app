# frozen_string_literal: true

require 'rubocop/rake_task'
RuboCop::RakeTask.new

feed_scripts = Dir['lib/feeds/*.rb']
feed_scripts.each do |f|
  require_relative f
end

feed_dists = feed_scripts.map { |f| File.join('dist', "#{File.basename(f, '.rb')}.xml") }

require 'rake/clean'
CLOBBER.add(['dist/index.html', *feed_dists])

multitask default: ['dist/index.html', *feed_dists]

file 'dist/index.html' => 'README.md' do |t|
  require 'commonmarker'
  html = Commonmarker.to_html(File.read('README.md'))
  File.write(t.name, html)
end

require 'active_support/core_ext/string/inflections'

feed_dists.each do |f|
  file f do |t|
    klass = File.basename(f, '.xml').camelize.constantize
    File.write(t.name, klass.build.to_rss)
  end
end

desc 'Build README.md'
task :readme do
  klass_to_uri = feed_dists.to_h do |f|
    klass = File.basename(f, '.xml').camelize.constantize
    uri = URI.join('https://rss.sankichi.app/', File.basename(f))
    [klass, uri]
  end

  content = <<~README
    # rss.sankichi.app

    Generate RSS feeds by scraping websites without native RSS support.

    ## Feeds

    Origin | Feed URL
    -- | --
    #{klass_to_uri.map { |klass, uri| "[#{klass.title}](#{klass.link}) | #{uri}" }.join("\n")}
  README

  File.write('README.md', content)
end
