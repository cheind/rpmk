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
    
    d = 8
    b = PMK::Box.new([-20.0]*d, [15.0]*d) 
    0.upto((2**d)-1) do |i| 
      bsub = b.split(i)
      0.upto(d-1) do |i| 
        len = bsub.upper[i] - bsub.lower[i]
        assert_in_delta(17.5, len, 1e-4)
      end
    end
    
    b = PMK::Box.new([0.0, 0.0], [1.0, 1.0])
    b = b.split(0).split(0).split(0).split(0)
    assert_equal_features([0.0, 0.0], b.lower)
    assert_equal_features([0.0625, 0.0625], b.upper)
    b = PMK::Box.new([0.0, 0.0], [1.0, 1.0])
    b = b.split(0).split(1).split(2).split(3)
    assert_equal_features([0.3125, 0.1875], b.lower)
    assert_equal_features([0.375, 0.25], b.upper)
  end
  
  def test_classify
    b = PMK::Box.new([0.0, 0.0], [1.0, 1.0])
    
    f = [[0.0, 0.0], [1.0, 1.0], [0.5, 0.5],
         [0.7, 0.7], [0.3, 0.3], [0.7, 0.2],
         [0.2, 0.85]]
    assert_equal({
      0 => [[0.0,0.0],[0.5,0.5],[0.3,0.3]], 
      1 => [[0.7,0.2]], 
      2 => [[0.2,0.85]],
      3 => [[1.0,1.0],[0.7,0.7]]}, b.classify(f))
  end
  
  def test_classify_random
    n = 1000
    d = 30
    features = Array.new(n) {Array.new(d){-20.0 + 40.0*rand()}}
    b = PMK::Box.new([-20.0]*d, [20.0]*d)
    r = b.classify(features)
    r.each do |id, fsub|
      bsub = b.split(id)
      fsub.each do |f|
        # test if f is within box
        0.upto(d-1) {|i| assert(bsub.lower[i] < f[i] && f[i] <= bsub.upper[i])}
      end
    end
  end
  
end
