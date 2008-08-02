require 'rubygems'
require 'test/unit'
require 'earworm'
require 'yaml'

class EarwormTest < Test::Unit::TestCase
  def setup
    settings = YAML.load_file(File.join(ENV['HOME'], '.earworm'))
    assert settings
    assert settings['assets']
    assert settings['key']
    @assets = settings['assets']
    @key = settings['key']
    @mp3 = Dir[@assets + "/*.mp3"].first
  end

  def test_ofa_version
    assert Earworm.ofa_version
  end

  def test_fingerprint
    ew = Earworm.new('123')
    key = ew.fingerprint(@mp3)
    assert key
  end

  def test_identify_file
    ew = Earworm.new(@key)
    info = ew.identify(:file => @mp3)
    assert info
    assert info.artist_name
    assert info.title
    assert info.puid_list.length > 0
  end

  #def test_idenfity_puid
  #  ew = Earworm.new(@key)
  #  info = ew.identify(:puid => 'f39d4c68-ab2d-5067-9a1a-c6b45a367906')
  #  assert info
  #  assert info.artist_name
  #  assert info.title
  #  assert info.puid_list.length > 0
  #  p info
  #end
end
