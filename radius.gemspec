# -*- encoding: utf-8 -*-

require File.join(File.dirname(__FILE__), 'lib', 'radius', 'version')
Gem::Specification.new do |s|
  s.name = %q{radius}
  s.version = ::Radius.version
  s.licenses = ["MIT"]

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{John W. Long (me@johnwlong.com)}, %q{David Chelimsky (dchelimsky@gmail.com)}, %q{Bryce Kerley (bkerley@brycekerley.net)}]
  s.description = %q{Radius is a powerful tag-based template language for Ruby inspired by the template languages used in MovableType and TextPattern. It uses tags similar to XML, but can be used to generate any form of plain text (HTML, e-mail, etc...).}
  s.email = %q{me@johnwlong.com}
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
end

