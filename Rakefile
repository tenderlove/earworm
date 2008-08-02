# -*- ruby -*-

require 'rubygems'
require './vendor/hoe.rb'

$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'earworm.rb'

Hoe.new('earworm', Earworm::VERSION) do |p|
  p.readme  = 'README.rdoc'
  p.history = 'CHANGELOG.rdoc'
  p.developer('Aaron Patterson', 'aaronp@rubyforge.org')
  p.extra_deps = [['icanhasaudio', '>=0.1.1']]
end

# vim: syntax=Ruby
