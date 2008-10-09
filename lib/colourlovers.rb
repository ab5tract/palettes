module Palettes
  module ColourLovers
    class Palette
      include Palettes::Mixin
 
      # It's a Party!
      require 'httparty'
      include HTTParty
      base_uri 'colourlovers.com'
      default_params :format => 'json'
      format :json
 
      def initialize(palette_id, names=false)
        get_palette(palette_id, names)
      end
 
      def get_palette(palette_id, names=false)
        raise ArgumentError unless palette_id.is_a? Integer
        @palette = get("api/palette/#{palette_id}")
        colors = @palette['colors']
 
        if names
          cnames=[]
          colors.each do |c|
            cnames << get("api/color/#{c}")[:title]
          end
          fill colors.map! { |c| [cnames.shift, c] }
        else
          fill colors
        end
      end
 
      def search(*keywords)
        words = keywords.inject {|ret,kw| ret += "+#{kw}"} if keywords.respond_to? :last
        words.gsub!(' ','+')
 
        get("api/palettes", :query => { :keywords => words })
      end
 
      # Return the raw hash response provided by HTTParty
      def response
        @palette
      end
    end
  end
end