#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

require './test/test_helper.rb'

class TestPyramideView < Test::Unit::TestCase
  include FeatureAssertions
  
  def test_init
    pyr = PMK::PyramideView.new(:ndims => 3, :nlevels => 10)
    assert_equal(8, pyr.nleaves)
  end
  
  def test_generate
    box = PMK::Box.new([0.0, 0.0], [1.0, 1.0])
    
    # level 2       0            0           0          0           0
    # level 1       0            3           2          2           1
    # level 0       0           15          11          11          6
    features = [[0.0, 0.0], [1.0, 1.0], [0.3, 0.8], [0.4, 0.9], [0.6, 0.4]]
    
    root = PMK::Subdivision.new(
      PMK::SubdivisionController.new(:nlevels => 3)
    ).generate(features, box)
    
    pyr = PMK::PyramideView.new(:ndims => 2, :nlevels => 3)
    view = pyr.generate(root)
    assert_equal(3, view.length)
    
    l0 = view[0] # most finegrained level
    assert_equal(4, l0.length)
    assert_equal(1, l0[0])
    assert_equal(1, l0[15])
    assert_equal(2, l0[11])
    assert_equal(1, l0[6])
    
    l1 = view[1]
    assert_equal(4, l1.length)
    assert_equal(1, l1[0])
    assert_equal(1, l1[3])
    assert_equal(2, l1[2])
    assert_equal(1, l1[1])
    
    l0 = view[2]
    assert_equal(1, l0.length)
    assert_equal(5, l0[0])    
  end
end
