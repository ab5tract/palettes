# Gems
require 'rubygems'

# Application Local
require 'mixin'

module Palettes
  class ColourLovers
    require 'httparty'
    
    include Palettes::Mixin

    def initialize(palette_id, names=false)
      @palette = self.class.get_palette(palette_id, names)
    end
    
    # CLASS METHODS!
    include HTTParty
  
    base_uri 'www.colourlovers.com'
#      default_params :format => 'json'
#      format :json

    default_params :format => 'xml'
    format :xml

    # Returns { :title => id }
    def self.search(*keywords)
      words = keywords.inject {|result,keywword| result += "+#{keyword}"} if keywords.respond_to? :last
      words.gsub!(' ','+')

      palettes = get("/api/palettes", :query => { :keywords => words })
      palettes = palettes['palettes']['palette'] # This gets us the array of palette hashes
      titles = []; ids = []; colors = []; creators = []
      palettes.each do |palette|
        titles << palette['title']
        ids << palette['id']
        colors << palette['colors']['hex']
        creators << palette['userName']
      end
      composites={}
      (0..(titles.length-1)).each {|x| composites[titles[x]] = {:id => ids[x], :colors => colors[x], :creator => creators[x]} }
      composites
    end
  
    def self.get_palette(palette_id, names=false)
      #raise ArgumentError unless palette_id.is_a? Integer
      @palette = get("/api/palette/#{palette_id.to_s}")
      colors ||= @palette['palettes']['palette']['colors']['hex']
      
      if names
        color_names=[]
        colors.each do |c|
          response = get("/api/color/#{c.to_s}")
          color_names << response['colors']['color']['title']
        end
        colors.map! { |c| [color_names.shift, c] }
      else
        colors
      end
    end

  end
end