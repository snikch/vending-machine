require "bundler/gem_tasks"

task default: :test

# MiniTest
require "rake/testtask"
Rake::TestTask.new do |t|
  ENV["TESTOPTS"] = "-v"
  t.pattern = "spec/*_spec.rb"
end

task :console do
  sh "irb -rubygems -I lib -r vend.rb"
end
