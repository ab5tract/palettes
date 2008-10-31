require 'rubygems'

require 'mixin'

module Palettes
  module ColourLovers
    require 'httparty'
    
    class Palette
      include Palettes::Mixin
 
      def initialize(palette_id, names=false)
        @palette = self.class.get_palette(palette_id, names)
      end
 
      # Return the raw hash response provided by HTTParty
      def response
        @palette
      end
      
      # CLASS METHODS!
      include HTTParty
    
      base_uri 'www.colourlovers.com'
      default_params :format => 'json'
      format :json
  
      # Returns { :title => id }
      def self.search(*keywords)
        words = keywords.inject {|result,keywword| result += "+#{keyword}"} if keywords.respond_to? :last
        words.gsub!(' ','+')

        palettes = get("/api/palettes", :query => { :keywords => words })
        
        titles = []; ids = []
        palettes.each do |palette|
          titles << palette['title']
          ids << palette['id']
        end
        composites={}
        (0..(titles.length-1)).each {|x| composites[titles[x]] = ids[x]}
        composites
      end
    
      def self.get_palette(palette_id, names=false)
        #raise ArgumentError unless palette_id.is_a? Integer
        @palette = get("/api/palette/#{palette_id.to_s}")
        colors ||= @palette.pop['colors']
        
        if names
          color_names=[]
          colors.each do |c|
            response = get("/api/color/#{c.to_s}")
            color_names << response.pop['title']
          end
          colors.map! { |c| [color_names.shift, c] }
        else
          colors
        end
      end
      
    end
  end
end