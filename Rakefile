# frozen_string_literal: true

require 'rake/testtask'
require 'rubocop/rake_task'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

RuboCop::RakeTask.new

desc 'Run tests and RuboCop'
task default: :test
task default: :rubocop
