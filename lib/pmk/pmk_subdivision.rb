#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

module PMK

  #
  # 
  #
  class PMKSubdivision < Subdivision
  
    #
    # Create a new node from values.
    #
    def PMKSubdivision.create_node(id, box, features, level)
      n = Subdivision.new(:nfeatures => features.length)
    end
    
  end
  
end
