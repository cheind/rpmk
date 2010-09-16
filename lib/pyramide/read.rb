#
# Pyramide Matching
# Copyright (c) Christoph Heindl, 2010
#

#
# Read features from CSV file
# Each feature corresponds to a single row.
# All rows are assumed to have an equal column count.
#
def read_csv(path, sep = ' ')
  features = []
  File.foreach(path) do |line|
    cells = line.split(sep)
    features << cells.map {|c| c.to_f}
  end
  features
end