module Earworm
  class Fingerprint
    def initialize(thing)
      @thing  = thing
      @hash   = nil
    end

    def to_hash
      return @hash if @hash
      info = nil
      if @thing.is_a?(IO)
        info = wav_info_for(@thing)
      else
        tmpfile = case @thing
                  when /mp3$/
                    decode_mp3(@thing)
                  when /wav$/
                    @thing
                  end
        File.open(tmpfile, 'rb') { |f|
          info = wav_info_for(f)
        }
      end
      @hash = {
        'fpt'  => info[:fpt],
        'art'  => 'unknown',
        'ttl'  => 'unknown',
        'alb'  => 'unknown',
        'tnm'  => 0,
        'gnr'  => 'unknown',
        'yrr'  => 0,
        'brt'  => 0,
        'fmt'  => 'wav',
        'dur'  => info[:milliseconds],
        'rmd'  => 1,
        'enc'  => '',
      }
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
  end
end
