# Gems
require 'rubygems'
require 'json'
require 'net/http'


def Kernel.engine; defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'mri'; end
require 'jruby/openssl/gem_only' if Kernel.engine == 'jruby'

# Application Local
require 'mixin'

module Palettes
  class ColourLovers
    
    include Palettes::Mixin

    def initialize(palette_id, names=false)
      @palette = self.class.get_palette(palette_id, names)
    end


    # Returns { :title => id }
    def self.search(*keywords)
      if keywords.respond_to? :assoc
        words = keywords.inject {|result,keyword| result += "+#{keyword}"}
        words.gsub!(' ','+')
      else
        words = keywords.gsub(' ','+')
      end

      palettes = ColourLovers.grab_list(words)
      return nil if palettes.empty?
      titles = []; ids = []; colors = []; creators = []
      palettes.each do |palette|
        titles << palette['title']
        ids << palette['id']
        colors << palette['colors']
        creators << palette['userName']
      end
      composites=[]
      (0..(titles.length-1)).each {|x| composites[x] = {:title => titles[x], :id => ids[x], :colors => colors[x], :creator => creators[x]} }
      composites
    end
  
    def self.get_palette(palette_id, names=false)
      #raise ArgumentError unless palette_id.is_a? Integer
      @palette = ColourLovers.grab_single palette_id.to_s
      colors ||= @palette.pop['colors']
      
      if names
        color_names=[]
        colors.each do |c|
          response = JSON.load( Net::HTTP.get( URI.parse "http://www.colourlovers.com/api/color/#{c.to_s}?format=json" ))
          color_names << response.pop['title']
        end
        colors.map! { |c| [color_names.shift, c] }
      else
        colors
      end
    end

    private
    def ColourLovers.grab_list(args)
      if args.is_a? Hash
          raise ArgumentError if args[:keywords].nil?
          params = args.inject {|p,(a,v)| p + "#{a}=#{b}&" } # We will always add a format, so don't fear the trailing '&'
      else
          params = "keywords=#{args}&" if args.is_a? String
      end
      json = JSON.load( Net::HTTP.get( URI.parse 'http://www.colourlovers.com/api/palettes?' + params + 'format=json' ))
    end

    def ColourLovers.grab_single(palette_id)
      json = JSON.load( Net::HTTP.get( URI.parse "http://www.colourlovers.com/api/palette/#{palette_id}?format=json" ))
    end
  end
end