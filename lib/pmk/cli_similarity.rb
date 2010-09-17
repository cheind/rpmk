#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

module PMK
  module CLI
    class Similarity
      def initialize(argv)
        require 'optparse'
        
        @opts = {}
        parser = OptionParser.new do |parser|
          @opts[:row_filter] = '**'
          @opts[:col_filter] = '**'
          @opts[:benchmark] = false
          
          parser.banner = "Usage: #{$0} [options] path [path ...]"
          parser.on('--row-filter F', 'Consider only rows whose basename matches F.') {|n| @opts[:row_filter] = n}
          parser.on('--col-filter F', 'Consider only columns whose basename matches F.') {|n| @opts[:col_filter] = n}
          parser.on('--nlevels F', Integer, 'Consider only first F levels in similarity calculation.') {|n| @opts[:nlevels] = n}
          parser.on_tail("--help", "Show this message") {puts parser; exit}
        end
        parser.parse!(argv) # Removes any parsed arguments
        
        if argv.empty?
          puts parser
          exit
        else
          @opts[:paths] = argv
        end
      end
      
      def run
        data = []
        @opts[:paths].each do |pattern| 
          Dir.glob(File.expand_path(pattern)).each do |path|
            data << [File.basename(path), File.open(path) {|f| Marshal.load(f)}]
          end
        end
        
        # Execute filters
        row_data = data.select do |x|
          File.fnmatch(@opts[:row_filter], x.first)
        end
        
        col_data = data.select do |x|
          File.fnmatch(@opts[:col_filter], x.first)
        end
        
        # Produce cross results 
        last_row = row_data.length-1
        last_col = col_data.length-1
        
        puts ";#{col_data.inject(''){|s, x| s += "#{x.first};"}.chomp(';')}"
        for i in 0..last_row do
          row = []
          for j in 0..last_col do
            row << PMK.similarity_normed(row_data[i].last, col_data[j].last, :nlevels => @opts[:nlevels])
          end
          puts "#{row_data[i].first};#{row.join(';')}"
        end
      end
    end
  end
end
