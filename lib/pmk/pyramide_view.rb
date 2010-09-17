#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

module PMK

  #
  # A view of a hierarchical subdivision that provides quick access individual tree-levels.
  #
  class PyramideView
    attr_reader :nleaves
    
    def initialize(dims, nlevels)
      @nleaves = 2**dims
      @nlevels = nlevels
    end
       
    def generate(subdivision_node)
      view = Array.new(@nlevels) {Hash.new(0)}
      self.build(view, subdivision_node, 0, 0, 0)
      view.reverse
    end
    
    protected
      
    #
    # Recursively prepare level view by uniquely assigning 
    # nodes per level a unique id.
    #
    def build(view, node, level, id, parent_id)
      level_pos = @nleaves * parent_id + id
      view[level][level_pos] = node[:nfeatures]
      node[:leaves].each do |leaf_id, leaf|
        self.build(view, leaf, level + 1, leaf_id, level_pos)
      end
    end
  end
end
