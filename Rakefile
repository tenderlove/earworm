# -*- ruby -*-

require 'rubygems'
require 'hoe'

$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'earworm'

Hoe.new('earworm', Earworm::VERSION) do |p|
  p.developer('Aaron Patterson', 'aaronp@rubyforge.org')
  p.description     = p.paragraphs_of('README.txt', 3..8).join("\n\n")
  p.extra_deps = [['icanhasaudio', '>=0.1.1']]
end

# vim: syntax=Ruby
