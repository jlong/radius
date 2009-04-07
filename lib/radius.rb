dir = File.join(File.dirname(__FILE__), 'radius')
require_files = %w{error tagdefs dostruct tagbinding context parsetag parser/scan parser util}
require_files.each {|f| require File.join(dir, f)}

module Radius
  VERSION = '0.6.1'
end
