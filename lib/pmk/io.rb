#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

module PMK
  module IO

    def IO.find_dimensions(path, sep = ' ')
      
    end

    #
    # Read features from CSV file
    # Each feature corresponds to a single row.
    # All rows are assumed to have an equal column count.
    #
    def IO.read_csv(path, sep = ' ')
      features = []
      File.foreach(path) do |line|
        cells = line.split(sep)
        features << cells.map {|c| c.to_f}
      end
      features
    end
    
  end
 end
