$: << File.join(File.dirname(__FILE__), '..', 'lib')
require 'radius'

if RUBY_PLATFORM == 'java'
  require 'java'
  require 'radius/parser/jscanner'
end

require 'benchmark'

document = <<EOF
Before it all
<r:foo>
  Middle Top
  <r:bar />
  Middle Bottom
</r:foo>
After it all
EOF

amount = 1000

Benchmark.bmbm do |bm|
  bm.report('vanilla') do
    scanner = RUBY_VERSION =~ /1\.9/ ? Radius::Scanner.new(:scanner => Radius::Scanner) : Radius::Scanner.new
    amount.times { scanner.operate('r', document) }
  end
  
  bm.report('vanilla (huge)') do
    scanner = RUBY_VERSION =~ /1\.9/ ? Radius::Scanner.new(:scanner => Radius::Scanner) : Radius::Scanner.new
    scanner.operate('r', 'a' * 460000)
  end

  if RUBY_PLATFORM == 'java'
    bm.report('JavaScanner') do
      scanner = Radius::JavaScanner.new(JRuby.runtime)
      amount.times { scanner.operate('r', document) }
    end
    
    bm.report('JavaScanner (huge)') do
      scanner = Radius::JavaScanner.new(JRuby.runtime)
      scanner.operate('r', 'a' * 460000)
    end
  end
end
