# Verify Palettes::ColourLovers with Test::Unit
require 'test/unit'

$:.unshift( File.join(File.dirname(__FILE__), "..", "..", "lib") )
require 'colourlovers'


class TestColourLovers < Test::Unit::TestCase
  
  def setup
    @simple = Palettes::ColourLovers.new 615398
    @named = Palettes::ColourLovers.new 615398, true
  end
  
  def test_simple_colorlovours
    assert_equal(@named[0], "C4C0BC")
    assert_equal(@simple.colors.length, 5)
    assert_nil(@simple.names)
    assert_equal(@simple.colors, ["C4C0BC", "F03048", "783030", "F0D8D8", "BFD182"])
    assert_equal(@simple.raw, @simple.colors)
  end
  
  def test_named_palette
    assert_equal(@named["members only"], "F03048")
    assert_equal(@named.to_hash, 
      {"members only"=>"F03048", "Putting Down Roots"=>"783030", "gorgeous"=>"F0D8D8", "green4"=>"BFD182", "times are tough"=>"C4C0BC"} 
    )
    assert_equal(@named.names, ["times are tough", "members only", "Putting Down Roots", "gorgeous", "green4"])
    assert_equal(@named.colors, ["C4C0BC", "F03048", "783030", "F0D8D8", "BFD182"])
    assert_equal(@named.raw, 
      [["times are tough", "C4C0BC"], ["members only", "F03048"], ["Putting Down Roots", "783030"], ["gorgeous", "F0D8D8"], ["green4", "BFD182"]]
    )
  end
  
end

[["times are tough", "C4C0BC"], ["members only", "F03048"], ["Putting Down Roots", "783030"], ["gorgeous", "F0D8D8"], ["green4", "BFD182"]]