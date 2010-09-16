#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

module PMK

  #
  # A view of a hierarchical subdivision that provides quick access to tree-levels.
  #
  class LevelView
    attr_reader :levels
    
    #
    # Initialize and build view from subdivision.
    #
    def initialize(subdivision, d, nlevels)
      @levels = Array.new(nlevels) {Hash.new(0)}
      @nleaves = 2**d
      self.build(subdivision, 0, 0, 0)
      @levels.reverse! # finest grid gets first pos, roughest last
    end
    
    #
    # Recursively prepare level view by uniquely assigning 
    # nodes per level a unique id.
    #
    def build(node, level, id, parent_id)
      pos = @nleaves * parent_id + id
      @levels[level][pos] = node[:nfeatures]
      node.leaves.each do |leaf_id, leaf|
        self.build(leaf, level + 1, leaf_id, pos)
      end
    end
  end
end
