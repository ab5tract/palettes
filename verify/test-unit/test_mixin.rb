# Verify Palettes::Mixin with Test::Unit
require 'test/unit'

$:.unshift( File.join(File.dirname(__FILE__), "..", "..", "lib") )
require 'mixin'


class TestMixin < Test::Unit::TestCase
  
  def setup
    klass = Class.new
    klass.class_eval {
      include Palettes::Mixin
      def initialize(colors); @palette=colors; end
    }
    @simple = klass.new [ "#eeeeee", "#666600" ]
    @named  = klass.new [ ["red", "#ff0000"], ["blue", "#0000ff"] ]
  end
  
  def test_nameless_palette
    assert_nil @simple.names
    assert_equal(@simple.colors.length, 2)
    assert_match(@simple[0], "#eeeeee")
    assert_match(@simple[1], "#666600")
  end
  
  def test_named_palette
    assert_equal(@named.names, ["red", "blue"])
    assert_match(@named[0], @named['red'])
    assert_match(@named[1], @named['blue'])
    assert_equal(@named.to_hash, {"blue"=>"#0000ff", "red"=>"#ff0000"} )
  end
end


class TestFill < Test::Unit::TestCase
  
  def setup
    klass = Class.new
    klass.class_eval {
      include Palettes::Mixin
      def initialize(colors=[]); @palette=colors; end
    }
    @simple = klass.new; @simple.fill [ "#444ead", "#55ab55"]
    @named  = klass.new; @named.fill  [ ["red", "#ff0000"], ["blue", "#0000ff"] ]
  end
  
  def test_simple_fill
    assert_equal(@simple.colors, [ "#444ead", "#55ab55"])
    assert_match(@simple[0], "#444ead")
    assert_match(@simple[1], "#55ab55")
  end
  
  def test_named_fill
    assert_equal(@named.colors, ["#ff0000", "#0000ff"])
    assert_match(@named['red'],  "#ff0000")
    assert_match(@named['blue'], "#0000ff")
  end
  
end