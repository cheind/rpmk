#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

require './test/test_helper.rb'

class TestBox < Test::Unit::TestCase
  include FeatureAssertions
  
  def test_attr
    b = PMK::Box.new([-1.0, -2.0], [3.0, 4.0])
    assert_equal_features([-1.0, -2.0], b.lower)
    assert_equal_features([3.0, 4.0], b.upper)
  end
  
  def test_center
    b = PMK::Box.new([-1.0, -2.0], [3.0, 5.0])
    assert_equal_features([1.0, 1.5], b.center)
  end
  
  def test_split
    b = PMK::Box.new([0.0, 0.0], [1.0, 1.0])
    b0  = b.split(0)
    assert_equal_features([0.0, 0.0], b0.lower)
    assert_equal_features([0.5, 0.5], b0.upper)
    
    b1 = b.split(1)
    assert_equal_features([0.5, 0.0], b1.lower)
    assert_equal_features([1.0, 0.5], b1.upper)

    b2 = b.split(2)
    assert_equal_features([0.0, 0.5], b2.lower)
    assert_equal_features([0.5, 1.0], b2.upper)
    
    b3 = b.split(3)
    assert_equal_features([0.5, 0.5], b3.lower)
    assert_equal_features([1.0, 1.0], b3.upper)
  end
end
