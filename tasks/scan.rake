namespace :scan do
  desc 'Generate the parsers'
  task 'build' => [
    'lib/radius/parser/scanner.rb',
    'lib/radius/parser/squiggle_scanner.rb',
    'lib/radius/parser/java_scanner.jar'
  ]
  
  desc 'Generate a PDF state graph from the parsers'
  task 'graph' => ['doc/scanner.pdf', 'doc/squiggle_scanner.pdf']
  
  desc 'turn the scanner.rl file into a ruby file'
  file 'lib/radius/parser/scanner.rb' => 'lib/radius/parser/scanner.rl' do |t|
    cd 'lib/radius/parser' do
      sh "ragel -R -F1 scanner.rl"
    end
  end
  
  desc 'turn the squiggle_scanner.rl file into a ruby file'
  file 'lib/radius/parser/squiggle_scanner.rb' =>
    ['lib/radius/parser/squiggle_scanner.rl'] \
  do |t|
    cd 'lib/radius/parser' do
      sh "ragel -R -F1 squiggle_scanner.rl"
    end
  end

  desc 'package JavaScanner into a jar file'
  file 'lib/radius/parser/java_scanner.jar' => 'lib/radius/parser/JavaScanner.class' do
    cd 'lib' do
      sh "jar -cf radius/parser/java_scanner.jar radius/parser/*.class"
    end
  end

  desc 'turn the JavaScanner.java file into a java class file'
  file 'lib/radius/parser/JavaScanner.class' => 'lib/radius/parser/JavaScanner.java' do |t|
    cd 'lib' do
      jruby_path = ENV['JRUBY_HOME'] || '/usr/local/jruby/current'
      sh "javac -cp #{jruby_path}/lib/jruby.jar radius/parser/JavaScanner.java"
    end
  end

  desc 'turn the JavaScanner.rl file into a java source file'
  file 'lib/radius/parser/JavaScanner.java' => 'lib/radius/parser/JavaScanner.rl' do |t|
    cd 'lib/radius/parser' do
      sh "ragel -J -F1 JavaScanner.rl"
    end
  end

  desc 'pdf of the ragel scanner'
  file 'doc/scanner.pdf' => 'lib/radius/parser/scanner.dot' do |t|
    cd 'lib/radius/parser' do
      sh "dot -Tpdf -o ../../../doc/scanner.pdf scanner.dot"
    end
  end

  desc 'pdf of the ragel squiggle scanner'
  file 'doc/squiggle_scanner.pdf' =>
    ['lib/radius/parser/squiggle_scanner.dot'] \
  do |t|
    cd 'lib/radius/parser' do
      sh "dot -Tpdf -o ../../../doc/squiggle_scanner.pdf squiggle_scanner.dot"
    end
  end

  file 'lib/radius/parser/scanner.dot' => 'lib/radius/parser/scanner.rl' do |t|
    cd 'lib/radius/parser' do
      sh "ragel -Vp scanner.rl > scanner.dot"
    end
  end

  file 'lib/radius/parser/squiggle_scanner.dot' =>
    ['lib/radius/parser/squiggle_scanner.rl'] \
  do |t|
    cd 'lib/radius/parser' do
      sh "ragel -Vp squiggle_scanner.rl > squiggle_scanner.dot"
    end
  end
end
