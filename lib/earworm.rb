require 'icanhasaudio'
require 'tempfile'
require 'earworm_lib'
require 'rexml/document'
require 'rexml/parsers/pullparser'

class Earworm
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

  attr_accessor :client_id
  def initialize(client_id)
    @client_id = client_id
  end

  def identify(options = {})
    post_opts = nil
    if options.key?(:file)
      fpt = fingerprint_to_hash(options[:file])
      post_opts = {
        'cid'  => @client_id,
        'cvr'  => 'Example 0.9.3',
        'fpt'  => fpt[:fpt],
        'art'  => 'unknown',
        'ttl'  => 'unknown',
        'alb'  => 'unknown',
        'tnm'  => 0,
        'gnr'  => 'unknown',
        'yrr'  => 0,
        'brt'  => 0,
        'fmt'  => 'wav',
        'dur'  => fpt[:milliseconds],
        'rmd'  => 1,
        'enc'  => '',
      }
    end
    xml = Net::HTTP.post_form(URI.parse(URL), post_opts).body
    puts xml
    require 'pp'
    parser = REXML::Parsers::PullParser.new(xml)
    while parser.has_next?
      pp parser.pull
    end
  end

  def fingerprint(filename)
    fingerprint_to_hash(filename)[:fpt]
  end

  private
  def fingerprint_to_hash(filename)
    if filename.is_a?(IO)
      return fingerprint_io(f)
    else
      tmpfile = case filename
                when /mp3$/
                  decode_mp3(filename)
                end
      File.open(tmpfile, 'rb') { |f|
        return fingerprint_io(f)
      }
    end
  end

  def decode_mp3(filename)
    reader = Audio::MPEG::Decoder.new
    name = File.join(Dir::tmpdir, "#{File.basename(filename, '.mp3')}.wav")
    File.open(filename, 'rb') { |input|
      File.open(name, 'wb') { |tmpfile|
        reader.decode(input, tmpfile)
      }
    }
    name
  end

  def fingerprint_io(io)
    header = io.read(4).unpack('N').first
    raise unless header == Audio::MPEG::Encoder::WAV_ID_RIFF
    info = Audio::MPEG::Encoder.parse_wave_header(io)
    bytes_in_seconds = 135 * info[:in_samplerate] * 2 * info[:num_channels]
    data = io.read(bytes_in_seconds)
    info[:fpt] = EarwormLib.ofa_create_print( data,
                                              0,
                                              bytes_in_seconds/2,
                                              info[:in_samplerate], 1)
    info
  end
end
