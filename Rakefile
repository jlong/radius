require 'bundler/gem_tasks'
require 'rake'

require File.dirname(__FILE__) + '/lib/radius/version'

Dir['tasks/**/*.rake'].each { |t| load t }

task :default => :test
