require 'foundations/compact'
require 'autocode'

require 'hoshi'

require 'views'
require 'palettes'


module PaletteApp
  include Waves::Foundations::Compact

  module Resources
    class Map

      # Set up our views
      @index = Views::Index.new
      assigns = {}
      
      on(:get, true) { @index = Views::Index.new; @index.show }

      on(:post, []) {
        result = Palettes::ColourLovers.search( query['keywords'] )
        @index ||= Views::Index.new
        if result.nil?
          @index.not_found query['keywords']
        else
          @index.search result, query['keywords']
        end
      }
    end
  end

end