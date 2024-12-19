source "https://rubygems.org"

gemspec

group :test do
  gem 'rdoc'
  gem 'rake'
  gem 'kramdown'
  gem "simplecov"
  gem 'coveralls_reborn', :require => false
  gem 'minitest'
end


platforms :rbx do
  gem 'racc'                     # if using gems like ruby_parser or parser
  # gem 'rubysl', '~> 2.0'
  gem 'psych'
  gem 'rubinius-developer_tools'
end

platforms :jruby do
  gem 'jar-dependencies', '~> 0.4.1'
end
