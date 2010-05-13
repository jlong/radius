namespace :scan do
  desc 'Generate the parsers'
  task 'build' => [
    'lib/radius/parser/scanner.rb',
    'lib/radius/parser/squiggle_scanner.rb'
  ]
  
  desc 'Generate a PDF state graph from the parsers'
  task 'graph' => ['doc/scanner.pdf', 'doc/squiggle_scanner.rb']
  
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
