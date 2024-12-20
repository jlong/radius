# -*- encoding: utf-8 -*-

require File.join(File.dirname(__FILE__), 'lib', 'radius', 'version')
Gem::Specification.new do |s|
  s.name = "radius"
  s.version = ::Radius.version
  s.licenses = ["MIT"]

  s.required_ruby_version = ">= 2.6.0"

  s.authors = ["John W. Long", "David Chelimsky", "Bryce Kerley"]
  s.description = %q{Radius is a powerful tag-based template language for Ruby inspired by the template languages used in MovableType and TextPattern. It uses tags similar to XML, but can be used to generate any form of plain text (HTML, e-mail, etc...).}
  s.email = ["me@johnwlong.com", "dchelimsky@gmail.com", "bkerley@brycekerley.net"]
  s.extra_rdoc_files = [
    "CHANGELOG",
    "CONTRIBUTORS",
    "LICENSE",
    "QUICKSTART.rdoc",
    "README.rdoc"
  ]

  ignores = File.read('.gitignore').split("\n").inject([]) {|a,p| a + Dir[p] }
  s.files = Dir['**/*','.gitignore'] - ignores

  s.homepage = %q{http://github.com/jlong/radius}
  s.summary = %q{A tag-based templating language for Ruby.}

  s.metadata = {
    "homepage_uri" => "https://github.com/jlong/radius",
    "source_code_uri" => "https://github.com/jlong/radius",
    "changelog_uri" => "https://github.com/jlong/radius/blob/master/CHANGELOG",
    "bug_tracker_uri" => "https://github.com/jlong/radius/issues"
  }

  s.platforms = [Gem::Platform::RUBY, 'java']
end

