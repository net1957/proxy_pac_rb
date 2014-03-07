require 'rubygems'
require "rake/testtask"

Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

namespace "test" do
  desc "Run tests with the rubyracer runtime"
  task "rubyracer" do
    gem "therubyracer"
    require "v8"
    Rake::Task["test"].invoke
  end

  desc "Run tests with the therubyrhino runtime"
  task "rubyrhino" do
    gem "therubyrhino"
    require "rhino"
    Rake::Task["test"].invoke
  end
end
