module Earworm
  class Fingerprint
    def initialize(thing)
      @thing  = thing
      @hash   = nil
    end

    def to_hash
      return @hash if @hash
      info = nil
      @hash = {
        'art'  => 'unknown',
        'ttl'  => 'unknown',
        'alb'  => 'unknown',
        'tnm'  => 0,
        'gnr'  => 'unknown',
        'yrr'  => 0,
        'brt'  => 0,
        'fmt'  => 'wav',
      }
      if @thing.is_a?(IO)
        info = wav_info_for(@thing)
      else
        tmpfile = case @thing
                  when /mp3$/
                    @hash['fmt'] = 'mp3'
                    begin
                      require 'id3lib'
                      @hash = @hash.merge(id3_info_for(@thing))
                    rescue LoadError
                    end
                    decode_mp3(@thing)
                  when /ogg$/
                    @hash['fmt'] = 'ogg'
                    decode_ogg(@thing)
                  else # Assume its a wav file
                    @thing
                  end
        File.open(tmpfile, 'rb') { |f|
          info = wav_info_for(f)
        }
      end
      @hash['fpt'] = info[:fpt]
      @hash['dur'] = info[:milliseconds]
      @hash
    end

    def to_s
      to_hash['fpt']
    end

    private
    def wav_info_for(io)
      header = io.read(4).unpack('N').first
      raise unless header == Audio::MPEG::Encoder::WAV_ID_RIFF
      info = Audio::MPEG::Encoder.parse_wave_header(io)
      bytes_in_seconds = 135 * info[:in_samplerate] * 2 * info[:num_channels]
      read_bytes =
        if info[:bytes_in_seconds] > bytes_in_seconds
          bytes_in_seconds
        else
          info[:bytes_in_seconds]
        end

      data = io.read(read_bytes)
      info[:fpt] = EarwormLib.ofa_create_print( data,
                                                0,
                                                read_bytes/2,
                                                info[:in_samplerate], 1)
      info
    end

    def id3_info_for(filename)
      tag = ID3Lib::Tag.new(filename)
      {
        'art'  => tag.artist,
        'ttl'  => tag.title,
        'alb'  => tag.album,
        'tnm'  => tag.track[/^(\d+)/],
        'gnr'  => tag.genre,
        'yrr'  => tag.year,
      }
    end

    {
      'ogg' => Audio::OGG::Decoder,
      'mp3' => Audio::MPEG::Decoder,
    }.each do |type,klass|
      define_method(:"decode_#{type}") do |filename|
        reader = klass.new
        name = File.join(Dir::tmpdir,
          "#{File.basename(filename, ".#{type}")}.wav")
        File.open(filename, 'rb') { |input|
          File.open(name, 'wb') { |tmpfile|
            reader.decode(input, tmpfile)
          }
        }
        name
      end
    end
  end
end
