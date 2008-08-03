module Earworm
  class Track
    attr_accessor :title, :artist_name, :puid_list
    alias :artist :artist_name
    def initialize
      @title = nil
      @artist_name = nil
      @puid_list = []
    end
  end
end
