Gem::Specification.new do |s|
   s.name = %q{palettes}
   s.version = "0.1.0"
   s.authors = ["ab5tract"]
   s.email = %q{john.haltiwanger@gmail.com}
   s.summary = %q{Palettes accesses the ColourLovers API through a Waves instance.}
   s.homepage = %q{http://github.com/ab5tract/palettes}
   s.description = %q{Palettes is for making masterpieces.}
   s.files = [ "bin/palettes", "lib/palettes.rb", "lib/colourlovers.rb", "lib/mixin.rb", "lib/waves/startup.rb", "lib/waves/views.rb"]
   %w[waves hoshi cassandra json].each {|dep| s.add_dependency(dep) }
   s.executables << 'palettes'
end
