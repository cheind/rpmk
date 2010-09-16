#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

module PMK

  #
  # Represents a node in hierarchical subdivision of space.
  #
  class Subdivision
    attr_reader :nfeatures, :leaves
    
    def initialize(nfeatures)
      @nfeatures = nfeatures
      @leaves = Hash.new
    end
    
    #
    # Generate a hierarchical subdivision of space.
    #
    def Subdivision.generate(features, world_box, nlevels)
      root = Subdivision.new(features.length)
      Subdivision.split(root, world_box, features, 1, nlevels - 1)
      root
    end
    
    # 
    # Recursive splitting of space into 2^d hyper-rectangles generated sparsley.
    #
    def Subdivision.split(parent, box, features, level, max_level)
      return if level > max_level
      # Classify each feature to a single sub-node
      clusters = box.classify(features)
      # Generate sub-nodes
      clusters.each do |id, sub_features|
        n = parent.leaves[id] = Subdivision.new(sub_features.length)
        Subdivision.split(n, box.split(id), sub_features, level + 1, max_level)
      end
    end
  end
  
end
