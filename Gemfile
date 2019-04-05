source "https://rubygems.org"

gemspec

group :test do
  gem 'rdoc'
  gem 'rake'
  gem 'kramdown'
  gem "simplecov"
  gem 'test-unit', '2.5.5'
  gem 'coveralls', :require => false
end


platforms :rbx do
  gem 'racc'                     # if using gems like ruby_parser or parser
  gem 'rubysl', '~> 2.0'
  gem 'psych'
  gem 'rubysl-test-unit'         # if using test-unit with minitest 5.x https://github.com/rubysl/rubysl-test-unit/issues/1
  gem 'rubinius-developer_tools'
end
