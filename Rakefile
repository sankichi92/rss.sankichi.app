# frozen_string_literal: true

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'rubocop/rake_task'
RuboCop::RakeTask.new

TARGETS = %w[
  dist/cao_space_policy.xml
].freeze

require 'rake/clean'
CLOBBER.add(*TARGETS)

multitask default: TARGETS

file 'dist/cao_space_policy.xml' do |t|
  require_relative 'lib/cao_space_policy'
  File.write(t.name, CAOSpacePolicy.new.to_rss)
end
