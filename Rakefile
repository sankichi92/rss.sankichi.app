# frozen_string_literal: true

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'rubocop/rake_task'
RuboCop::RakeTask.new

TARGETS = %w[
  dist/index.html
  dist/cao_space_policy.xml
  dist/mext_space_wg.xml
].freeze

require 'rake/clean'
CLOBBER.add(*TARGETS)

multitask default: TARGETS

file 'dist/index.html' do |t|
  require 'commonmarker'
  html = Commonmarker.to_html(File.read('README.md'))
  File.write(t.name, html)
end

file 'dist/cao_space_policy.xml' do |t|
  require_relative 'lib/cao_space_policy'
  File.write(t.name, CAOSpacePolicy.new.to_rss)
end

file 'dist/mext_space_wg.xml' do |t|
  require_relative 'lib/mext_space_wg'
  File.write(t.name, MEXTSpaceWG.new.to_rss)
end
