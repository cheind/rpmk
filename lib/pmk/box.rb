#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

module PMK

  class Box
    attr_reader :lower, :upper

    # Initialize from lower and upper corner vector
    def initialize(lo, up)
      @lower = lo
      @upper = up
      @d = lo.length
    end
    
    #
    # Center of box
    #
    def center
      center = Array.new(@d)
      for di in 0..(@d-1) do
        center[di] = (@lower[di] + @upper[di]) * 0.5
      end
      center
    end
    
    #
    # Calculate box, indexed by id, containing the sub-space of this box
    # when each dimension is split in half.
    #
    # When each dimension is split in half 2^dims sub-boxes can be formed.
    # Each integer in [0, 2^dims - 1] references a unique sub-box. 
    #
    #     y
    #     ^
    # +---+---+
    # | 2 | 3 |
    # +---+---+ -> x
    # | 0 | 1 |
    # +---+---+
    #
    def split(id)
      c = self.center
      b = Box.new(Array.new(@d), Array.new(@d))
      for di in 0..(@d-1) do
        mask = id & (1 << di)
        b.upper[di] = (mask == 0) ? c[di] : @upper[di]
        b.lower[di] = (mask == 0) ? @lower[di] : c[di]
      end
      b
    end
    
    #
    # Assigns each feature to indexed sub-space of this box.
    # 
    def classify(features)
      clusters = {}
      center = self.center
      features.each do |f|
        id = 0
        for di in 0..(@d-1) do
          id |= 1 << di if f[di] > center[di]
        end
        a = (clusters[id] ||= Array.new)
        a << f
      end
      clusters
    end
  end
end
