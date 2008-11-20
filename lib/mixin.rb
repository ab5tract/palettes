# Palettes::Mixin
# Provides basic palette methods.
 
module Palettes
 
  module Mixin
    attr_reader :colors
 
    # Palette colors may be supplied as an array of values, or an array of name/value pairs:
    # Palette.new [ "#eeeeee", "#666600" ]
    # Palette.new [ ["red", "#ff0000"], ["blue", "#0000ff"] ]
 
    def fill(color_array)
      @palette = color_array
    end

    def colors
      colors = []
      # We could use #map here, but then I'd have to use #compact
      @palette.each { |c| c.respond_to?( :assoc ) ? colors << c.last : colors << c }
      colors
    end
 
    def names
      n = []
      # We could use #map here, but then I'd have to use #compact
      @palette.each { |c| c.respond_to?( :assoc ) ? n << c.first : nil }
      n.empty? ? nil : n
    end
 
    def [](arg)
      color = arg.is_a?(Integer) ? @palette[arg] : @palette.assoc(arg)
      color.respond_to?(:last) ? color.last : color
    end
 
    def to_hash
      Hash[ *@palette.flatten ]
    end
    
    def raw
      @palette
    end
    
  end
 
end