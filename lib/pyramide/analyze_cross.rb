#
# Pyramide Matching
# Copyright (c) Christoph Heindl, 2010
#

require 'read'

#
# Read matrix from CSV file, first line is considered header
#
def read_matrix(path, sep = ' ')
  matrix = []
  File.foreach(path) do |line|
    cells = line.split(sep)
    matrix << cells.map do |c| 
      c.chop!
      begin
        Float(c)
      rescue ArgumentError
        c
      end
    end
  end
  matrix[0..-2]
end

def find_link_id(row_name, col_names)
  r = /^.*(\d+)/
  raise ArgumentError unless row_name =~ r
  row = $1
  col_id = col_names.index(col_names.detect{|x| x =~ r && $1 == row})
  col_id
end

if __FILE__ == $0 
  if ARGV.empty?
    puts "Usage: Usage: #{__FILE__} path"
    exit
  end
  
  matrix = read_matrix(ARGV[0], ';')
  nrows = matrix.length
  ncols = matrix.first.length
  
  chance_tbf = 0
  chance_tbf_a = []
  chance_boot = 0
  chance_tb80 = 0
  
  matrix[1..-1].each do |row|
    ranked_ids = (1..ncols-1).to_a.sort{|x,y| row[y] <=> row[x]}
    should_id = find_link_id(row[0], matrix[0]) 
    chance_tbf += 1 if should_id == ranked_ids.first
    chance_tbf_a << ((should_id == ranked_ids.first) ? 1 : 0)
    chance_boot += 1 if ranked_ids.index(should_id) < 4
    chance_tb80 += 1 if (row[should_id] / row[ranked_ids.first]) > 0.8
  end
  
  puts "chance_tbf_a #{chance_tbf_a.join(',')}"
  puts "chance_tbf #{chance_tbf.to_f/(nrows-1)}"
  puts "chance_boot #{chance_boot.to_f/(nrows-1)}"
  puts "chance_tb80 #{chance_tb80.to_f/(nrows-1)}"
end