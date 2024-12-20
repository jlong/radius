require 'bundler/gem_tasks'
require 'rake'

require File.dirname(__FILE__) + '/lib/radius/version'

Dir['tasks/**/*.rake'].each { |t| load t }

task :default => :test

namespace :build do
  desc "Build both Ruby and Java platform gems"
  task :all do
    version = ::Radius.version
    system "gem build radius.gemspec --platform ruby -o radius-#{version}.gem"
    system "gem build radius.gemspec --platform java -o radius-#{version}-java.gem"
  end
end
