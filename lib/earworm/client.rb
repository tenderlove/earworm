module Earworm
  class Client
    attr_accessor :client_id
    def initialize(client_id)
      @client_id = client_id
    end

    def identify(options = {})
      post_opts = nil
      if options.key?(:file)
        post_opts = {
          'cid'  => @client_id,
          'cvr'  => "Earworm #{VERSION}",
          'rmd'  => 1,
          'enc'  => '',
        }.merge(Fingerprint.new(options[:file]).to_hash)
      end
      xml = Net::HTTP.post_form(URI.parse(URL), post_opts).body
      parser = REXML::Parsers::PullParser.new(xml)
      track = Track.new
      while parser.has_next?
        thing = parser.pull
        if thing.start_element?
          case thing[0]
          when 'title'
            track.title = parser.pull[0]
          when 'name'
            track.artist_name = parser.pull[0]
          when 'puid'
            track.puid_list << thing[1]['id']
          end
        end
      end
      track
    end

    def fingerprint(filename)
      Fingerprint.new(filename).to_s
    end
  end
end
