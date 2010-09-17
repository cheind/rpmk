#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

module PMK

  #
  # Represents a node in hierarchical subdivision of space.
  #
  class SubdivisionNode
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
    
        
    def SubdivisionNode.pre_order(root, &block)
      stack = [root]
      while !stack.empty?
        n = stack.pop
        block.call(n)
        n[:leaves].each do |id, leaf|
          stack.push(leaf)
        end
      end
    end
    
   end
   
   class Subdivision
  
    def initialize(controller)
      @controller = controller
    end
    
    #
    # Generate a hierarchical subdivision of space.
    #
    def generate(features, world_box)
      root = nil
      unless @controller.stop?(nil, world_box, features, 0)
        root = @controller.create(nil, world_box, features, 0, 0)
        self.split(root, world_box, features, 1)
      end
      root
    end
    
    protected
    
    # 
    # Recursive splitting of space into 2^d hyper-rectangles generated sparsley.
    #
    def split(parent, box, features, level)
      return if @controller.stop?(parent, box, features, level)
      # Classify each feature to a single sub-node
      clusters = box.classify(features)
      # Generate sub-nodes
      next_level = level + 1
      clusters.each do |id, sub_features|
        sub_box = box.split(id)
        n = parent[:leaves][id] = @controller.create(parent, sub_box, sub_features, level, id)
        self.split(n, sub_box, sub_features, next_level)
      end
    end   
  end
  
end
