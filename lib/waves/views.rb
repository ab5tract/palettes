require 'cassandra'

module Views
  class Index < Hoshi::View(:xhtml1)
    def show
      doctype
      html {
        head {
          title "Palettes"
        }
        body(:bgcolor => "#BCBDAC", :style => "font-family: sans-serif") {
          h1 "Palettes"
          h3 "A Simple Interface to Glorious Possibility"
          form(:action => '/', :method => 'post') {
            input(:type => 'text', :name => 'keywords')
            input(:type => 'submit', :value => 'Search')
          }
        }
      }
      render
    end

    def not_found(keywords)
      doctype
      html {
        head {
          title "Palettes: No palettes found :("
        }
        body(:bgcolor => "#BCBDAC", :style => "font-family: sans-serif") {
          h1 "No palettes found for #{keywords} :("
        }
      }
      render
    end

    def search(result, keywords)
      doctype
      html {
        head {
          # Begin Cassandra
          @css = Cssy.new
          @css.process {

            li.palette_box {
              border(:solid)
              margin_bottom('3em')
              background_color("#DBE6EC")
              width('780px')
              height('350px')
              position(:relative)
              z_index('1')
            }

            td.color_bar {
              vertical_align(:top)
              font_size('xx-small')
            }

            table.colors {
              width('440px');
              height('330px');
              border(:solid);
              margin('10px');
              position(:relative)
              z_index('2')
            }

            div.info_box {
              position(:absolute)
              top('0px')
              left('480px')
              z_index('2')
              width("295px")
            }

            dl.info {
              margin_top("1.5em")
              list_style(:none)
              position(:relative)
            }

            dd{
              margin_left('1em')
              padding('0')
            }

            ul.colors { list_style(:none); margin("0") }
            li.colors { margin_left("3px") }
            ol.palettes { list_style(:none); position(:relative) }
            body { position(:relative) }
            a { color(:black); text_decoration(:none) }
            selector("a:hover") { text_decoration(:underline) }
          }
          style @css.to_s, "type"=>"text/css"
          # End Cassandra

          title "Palette Search: #{keywords}"
        }
        body(:bgcolor => "#BCBDAC", :style => "font-family: sans-serif") {
          h1 "Palettes"
          h3 "Search results for: #{keywords}"
          ol(:class => "palettes") {
          result.each do |r|
            li(:class => "palette_box") {
              table(:class => "colors", 'cellspacing' => '0px' ) { tr {
                r[:colors].each {|color|
                  td(:class => 'color_bar', :title => "##{color}",
                  :style => " width: #{440/r[:colors].length}px;
                              color: ##{color};
                              background-color: ##{color}") { raw "##{color}" }
                }#td (loop)
              } }#tr, table.colors
              div(:class => "info_box") {
                h2 { a(:href => "http://colourlovers.com/palette/#{r[:id].to_s}") { raw "Palette #{r[:id].to_s}" } }
                dl(:class => "info") {
                  dt { raw "Title: " }
                  dd { raw "#{r[:title]}"}
                  dt { raw "Creator: " }
                  dd { raw "#{r[:creator]}"}
                  dt { raw "Colors: " }
                  dd { ul(:class => "colors") { r[:colors].each {|color| li(:class=>"colors") { raw "##{color}" } }}}
                }#dl.info
              }#div.info_box
            }#li.palette_box
          end
          }#ol.palettes
        }
      }
      render
    end

  end
end