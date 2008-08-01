require 'rubygems'
require 'test/unit'
require 'earworm'

class EarwormTest < Test::Unit::TestCase
  def test_ofa_version
    assert Earworm.ofa_version
  end

  def test_fingerprint
    ew = Earworm.new('123')
    key = ew.fingerprint('/tmp/kl.mp3')
    assert key
  end

  def test_identify
    ew = Earworm.new('a7f6063296c0f1c9b75c7f511861b89b')
    assert ew.identify(:file => '/tmp/kl.mp3')
  end
end
