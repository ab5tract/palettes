# Palettes::Mixin
# Provides basic palette methods.
 
module Palettes
 
  module Mixin
    attr_reader :colors
 
    # Palette colors may be supplied as an array of values, or an array of name/value pairs:
    # Palette.new [ "#eeeeee", "#666600" ]
    # Palette.new [ ["red", "#ff0000"], ["blue", "#0000ff"] ]
 
    def fill(color_array)
      @colors = color_array
    end
 
    def names
      n = []
      # We could use #map here, but then I'd have to use #compact
      @colors.each { |c| c.respond_to?( :first ) ? n << c.first : nil }
      n
    end
 
    def [](arg)
      color = arg.is_a?(Integer) ? @colors[arg] : @colors.assoc(arg)
      color.respond_to?(:last) ? color.last : color
    end
 
    def to_hash
      Hash[ *@colors.flatten ]
    end
  end
 
end