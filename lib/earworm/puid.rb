module Earworm
  class PUID
    def initialize(puid)
      @puid = puid
    end

    def to_hash
      {
        'puid' => @puid,
        'art'  => 'unknown',
        'ttl'  => 'unknown',
        'alb'  => 'unknown',
        'tnm'  => 0,
        'gnr'  => 'unknown',
        'yrr'  => 0,
      }
    end

    def to_s; @puid; end
  end
end
