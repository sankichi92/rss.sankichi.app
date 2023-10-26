# frozen_string_literal: true

require 'rubocop/rake_task'
RuboCop::RakeTask.new

TARGETS = %w[
  dist/index.html
  dist/cao_space_policy.xml
  dist/made_in_abyss.xml
  dist/mext_space_wg.xml
].freeze

require 'rake/clean'
CLOBBER.add(*TARGETS)

multitask default: TARGETS

file 'dist/index.html' => 'README.md' do |t|
  require 'commonmarker'
  html = Commonmarker.to_html(File.read('README.md'))
  File.write(t.name, html)
end

file 'dist/cao_space_policy.xml' do |t|
  require_relative 'lib/cao_space_policy'
  File.write(t.name, CAOSpacePolicy.build.to_rss)
end

file 'dist/made_in_abyss.xml' do |t|
  require_relative 'lib/made_in_abyss'
  File.write(t.name, MadeInAbyss.build.to_rss)
end

file 'dist/mext_space_wg.xml' do |t|
  require_relative 'lib/mext_space_wg'
  File.write(t.name, MEXTSpaceWG.build.to_rss)
end
