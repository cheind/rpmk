#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

module PMK
  #
  # Generates a level-view of an hierarchical subdivision of features read from file.
  #
  def PMK.prepare_file(path_to_csv, world_box, nlevels)
    output_lv = File.join(
      File.dirname(path_to_csv), 
      File.basename(path_to_csv))
    output_lv += '.lv'

    d = world_box.lower.length
    printf "generating #{File.basename(output_lv)} "
    features = read_csv(path_to_csv); printf '.'
    subdiv = Subdivision.generate(features, world_box, nlevels); printf '.'
    lv = LevelView.new(subdiv, d, nlevels); puts '.'
    File.open(output_lv, 'w') {|f| Marshal.dump(lv, f)}
    lv
  end
end


# In case prepare is called directly by user.
# Converts a list of objects, each given as a list of features, 
# into LevelViews and dumps them as '.lv' files.
if __FILE__ == $0
  require 'optparse'
  
  opts = {}
  parser = OptionParser.new do |parser|
    opts[:sep] = ' '
    parser.banner  = "Usage: #{__FILE__} [options] path path*\n"
    parser.banner += "Examples\n"
    parser.banner += "  ruby #{__FILE__} --maxlevel 5 --world_min 0 --world_max 1 d:\\a\\**\*.csv d:\\b\\*.csv"
    parser.separator("") 
    parser.separator("Options:") 
    parser.on("--sep S", "Separator in CSV") {|n| opts[:sep] = n}
    parser.on("--nlevels N", Integer, "Number of tree levels") {|n| opts[:nlevels] = n}
    parser.on("--world_min N", Float, "Minimum bounds of world") {|n| opts[:world_min] = n}
    parser.on("--world_max N", Float, "Maximumg bounds of world") {|n| opts[:world_max] = n}
    parser.on_tail("--help", "Show this message") {puts parser; exit}
    
  end
  parser.parse! # Removes any parsed arguments
  if ARGV.empty? || opts.length != 4
    puts parser
    exit
  end
  
  puts 
  puts "Options are #{opts}"
  
  # Determine dimensionality from first row in first path
  sep = ' '
  dims = File.open(ARGV[0]) {|f| f.readline.split(opts[:sep]).length}
  # Prepare each path in turn
  world = Box.new([opts[:world_min]]*dims, [opts[:world_max]]*dims)
  ARGV.each do |pattern| 
    Dir.glob(File.expand_path(pattern)).each do |path| 
      prepare_file(path, world, opts[:nlevels])
    end
  end
end
