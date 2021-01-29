# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"

# MiniTest
ENV["TESTOPTS"] = "-v"
Rake::TestTask.new do |t|
  t.libs << "test"
end

# RuboCop
RuboCop::RakeTask.new

task default: :test
