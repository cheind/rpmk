#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

module PMK

  class SubdivisionController
    def initialize(nlevels)
      @max_level = nlevels - 1
    end
    
    def stop?(parent, box, features, level)
      level > @max_level
    end
    
    def create(parent, box, features, level, id)
      SubdivisionNode.new(:nfeatures => features.length)
    end
  end
end
