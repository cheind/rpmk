#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

module PMK
  module CLI
    
    class Prepare
      def initialize(argv)
        require 'optparse'
        
        @opts = {}
        parser = OptionParser.new do |parser|
          @opts[:sep] = ' '
          parser.banner  = "Usage: #{$0} [options] path [path, ...]\n"
          parser.separator('') 
          parser.separator('Options:') 
          parser.on('--sep S', 'Separator in CSV, defaults to space.') {|n| @opts[:sep] = n}
          parser.on('--nlevels N', Integer, 'Number of tree levels') {|n| @opts[:nlevels] = n}
          parser.on('--world_min N', Float, 'Minimum bounds of world') {|n| @opts[:world_min] = n}
          parser.on('--world_max N', Float, 'Maximumg bounds of world') {|n| @opts[:world_max] = n}
          parser.on_tail('--help', 'Show this message') {puts parser; exit}
        end
        parser.parse!(argv)

        
        if argv.empty? || @opts.length != 4
          puts parser
          exit
        else
          @opts[:paths] = argv # whatever is unparsed is considered a path
        end
      end
      
      def run
        puts 
 
        # Determine dimensionality from first row in first path
        opts[:dims] = PMK::IO.find_dimensions(@opts[:paths][0], @opts[:sep])
        puts "Assuming #{dims} dimensions."
        
        # Prepare each path in turn
        world = Box.new([@opts[:world_min]]*opts[:dims], [@opts[:world_max]]*opts[:dims])
        @opts[:paths].each do |pattern| 
          Dir.glob(File.expand_path(pattern)).each do |path| 
            prepare_file(path, world, @opts[:nlevels])
          end
        end
      end
      
      private
      
      def prepare_file(path_to_csv, world_box)
        output_lv = File.join(
          File.dirname(path_to_csv), 
          File.basename(path_to_csv))
        output_lv += '.lv'

        printf 'generating #{File.basename(output_lv)} '
        features = PMK::IO::read_csv(path_to_csv, @opts[:sep]); printf '.'
        
        root = PMK::Subdivision.new(
          PMK::SubdivisionController.new(:nlevels => @opts[:nlevels])
        ).generate(features, world_box); printf '.'
        
        pyr = PMK::PyramideView.new(:ndims => opts[:dims], :nlevels => @opts[:nlevels])
        levels = pyr.generate(root); puts '.'
        
        File.open(output_lv, 'w') {|f| Marshal.dump(levels, f)}
      end
    end
  end
end
