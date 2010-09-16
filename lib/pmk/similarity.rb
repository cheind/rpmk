#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

module PMK

  #
  # Calculates the symmetric similarity, K, between two level views
  #
  def PMK.similarity(lv_a, lv_b, use_nlevels = nil)
    stop = lv_a.levels.length - 1
    start = use_nlevels ? [0, lv_a.levels.length - use_nlevels].max : 0

    last = 0
    w = 1.0
    k = 0.0
    for lev in start..stop do
      h_a = lv_a.levels[lev]
      h_b = lv_b.levels[lev]
      i = 0
      h_a.each do |id, c_a|
        c_b = h_b[id]
        i += c_a < c_b ? c_a : c_b
      end

      n = i - last
      k += w * n
      last = i
      w *= 0.5
    end
    k
  end

  #
  # Calculate the normed similarity between two level views.
  #
  def PMK.similarity_normed(lv_a, lv_b, max_level = nil)
    k_ab = similarity(lv_a, lv_b, max_level)
    k_aa = lv_a.levels.last[0]
    k_bb = lv_b.levels.last[0]
      
    k_ab/Math::sqrt(k_aa*k_bb)
  end
end

# In case similarity is called directly by user.
# Calculates the cross similarities between a list of saved level views.
if __FILE__ == $0
  require 'optparse'
  require 'benchmark'
  
  opts = {}
  parser = OptionParser.new do |parser|
    opts[:row_filter] = '**'
    opts[:col_filter] = '**'
    opts[:benchmark] = false
    parser.banner = "Usage: #{__FILE__} [options] path path*"
    parser.banner += "Examples\n"
    parser.banner += "  ruby #{__FILE__} --row-filter *f_s* --col-filter --nlevels 4 d:\pyr_match\output\**\*.lv"
    parser.on('--row-filter F', 'Consider only rows whose basename matches F.') {|n| opts[:row_filter] = n}
    parser.on('--col-filter F', 'Consider only columns whose basename matches F.') {|n| opts[:col_filter] = n}
    parser.on('--nlevels F', Integer, 'Consider only first F levels in similarity calculation.') {|n| opts[:nlevels] = n}
    parser.on( '-b', '--benchmark', 'Output timings before exiting' ) {|n| opts[:benchmark] = true}
    parser.on_tail("--help", "Show this message") {puts parser; exit}
  end
  parser.parse! # Removes any parsed arguments
  
  if ARGV.empty?
    puts parser
    exit
  end
  
  data = []
  ARGV.each do |pattern| 
    Dir.glob(File.expand_path(pattern)).each do |path|
      data << [File.basename(path), File.open(path) {|f| Marshal.load(f)}]
    end
  end
  
  # Execute filters
  row_data = data.select do |x|
    File.fnmatch(opts[:row_filter], x.first)
  end
  
  col_data = data.select do |x|
    File.fnmatch(opts[:col_filter], x.first)
  end
  
  # Produce cross results 
  last_row = row_data.length-1
  last_col = col_data.length-1
  
  puts ";#{col_data.inject(''){|s, x| s += "#{x.first};"}.chomp(';')}"
  bench = Benchmark.measure {
    for i in 0..last_row do
      row = []
      for j in 0..last_col do
        row << similarity_normed(row_data[i].last, col_data[j].last, opts[:nlevels])
      end
      puts "#{row_data[i].first};#{row.join(';')}"
    end
  }
  puts
  puts "Timings: " + bench.to_s if opts[:benchmark]
end
