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
    attr_reader :data
    
    def initialize(data = nil)
      @data = Hash.new
      @data[:leaves] = Hash.new
      @data.merge!(data) if data
    end
    
    #
    # Associate key/value with this node
    #
    def []=(key, value)
      @data[key] = value
    end
    
    #
    # Access a stored value.
    #
    def [](key)
      @data[key]
    end
    
    #
    # Generate a hierarchical subdivision of space.
    #
    def Subdivision.generate(features, world_box, nlevels)
      root = self.create_node(0, world_box, features, 0)
      self.split(root, world_box, features, 1, nlevels - 1)
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
      next_level = level + 1
      clusters.each do |id, sub_features|
        sub_box = box.split(id)
        n = parent[:leaves][id] = self.create_node(id, sub_box, sub_features, next_level)
        self.split(n, sub_box, sub_features, next_level, max_level)
      end
    end
    
    protected
    
    #
    # Create a new node from values.
    #
    def Subdivision.create_node(id, box, features, level)
      raise NotImplementedError
    end
    
  end
  
end
