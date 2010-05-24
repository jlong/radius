desc "remove Rubinius rbc files"
task "rubinius:clean" do
  (Dir['**/*.rbc']).each { |f| rm f }
end