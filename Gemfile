source "https://rubygems.org"

gemspec

group :test do
  gem 'rdoc'
  gem 'rake'
  gem 'kramdown'
  gem "simplecov"
  gem 'coveralls', :require => false
  gem 'minitest'
end


platforms :rbx do
  gem 'racc'                     # if using gems like ruby_parser or parser
  gem 'rubysl', '~> 2.0'
  gem 'psych'
  gem 'rubinius-developer_tools'
end
