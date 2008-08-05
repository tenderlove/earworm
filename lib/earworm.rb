require 'icanhasaudio'
require 'tempfile'
require 'earworm_lib'
require 'earworm/track'
require 'earworm/puid'
require 'earworm/fingerprint'
require 'earworm/client'
require 'rexml/document'
require 'rexml/parsers/pullparser'
require 'net/http'

module Earworm
  VERSION = '0.0.1'
  URL = 'http://ofa.musicdns.org/ofa/1/track'
  class << self
    def ofa_version
      major = DL.malloc(DL.sizeof('I'))
      minor = DL.malloc(DL.sizeof('I'))
      rev = DL.malloc(DL.sizeof('I'))
      major.struct!('I', 'val')
      minor.struct!('I', 'val')
      rev.struct!('I', 'val')
      EarwormLib.ofa_get_version(major, minor, rev)
      "#{major['val']}.#{minor['val']}.#{rev['val']}"
    end
  end
end
