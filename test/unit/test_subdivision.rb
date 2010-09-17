#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

require './test/test_helper.rb'

class MySubdivisionController
  def initialize(nlevels)
    @max_level = nlevels - 1
  end
  
  def stop?(parent, box, features, level)
    level > @max_level
  end
  
  def create(parent, box, features, level, id)
    PMK::SubdivisionNode.new(
      :id => id, 
      :box => box, 
      :features => features, 
      :level => level)
  end
end

class TestSubdivision < Test::Unit::TestCase
  include FeatureAssertions
  
  def test_node_data
    n = PMK::SubdivisionNode.new(:x => 3, :y => 4)
    assert_instance_of(Hash, n[:leaves])
    assert_equal(3, n[:x])
    assert_equal(4, n[:y])
    
    n[:x] = 10
    n[:z] = "test"
    assert_equal(10, n[:x])
    assert_equal("test", n[:z])    
  end
  
  def test_subdivision
    box = PMK::Box.new([0.0, 0.0], [1.0, 1.0])
    features = [[0.0, 0.0], [1.0, 1.0], [0.3, 0.7]]
    
    root = PMK::Subdivision.new(MySubdivisionController.new(2)).generate(features, box)
    assert_equal(0, root[:id])
    assert_equal(0, root[:level])
    assert_equal_features([0.0, 0.0], root[:box].lower)
    assert_equal_features([1.0, 1.0], root[:box].upper)
    assert_equal(features, root[:features])
    assert_equal(3, root[:leaves].length)
    
    l0 = root[:leaves][0]
    assert_equal(0, l0[:leaves].length)
    assert_equal(1, l0[:level])
    assert_equal([0.0, 0.0], l0[:box].lower)
    assert_equal([0.5, 0.5], l0[:box].upper)
    assert_equal([[0.0, 0.0]], l0[:features])
    
    l1 = root[:leaves][1]
    assert_nil(l1)

    l2 = root[:leaves][2]
    assert_equal(0, l2[:leaves].length)
    assert_equal(1, l2[:level])
    assert_equal([0.0, 0.5], l2[:box].lower)
    assert_equal([0.5, 1.0], l2[:box].upper)
    assert_equal([[0.3, 0.7]], l2[:features])

    l3 = root[:leaves][3]
    assert_equal(0, l3[:leaves].length)
    assert_equal(1, l3[:level])
    assert_equal([0.5, 0.5], l3[:box].lower)
    assert_equal([1.0, 1.0], l3[:box].upper)
    assert_equal([[1.0, 1.0]], l3[:features])
  end
  
  def test_subdivision_random
    n = 2000
    d = 2
    levs = 10
    features = Array.new(n) {Array.new(d){-20.0 + 40.0*rand()}}
    box = PMK::Box.new([-20.0]*d, [20.0]*d)
    
    root = PMK::Subdivision.new(MySubdivisionController.new(levs)).generate(features, box)
    sum_each_level = Array.new(levs, 0)
    PMK::SubdivisionNode.pre_order(root) do |node|
      assert(node[:id] >= 0 && node[:id] < 2**d)
      box = node[:box]
      0.upto(d-1) {|i| assert_equal(box.upper[i] - box.lower[i], 40.0/(2**node[:level]))}      
      sum_each_level[node[:level]] += node[:features].length
      node[:features].each do |f|
        # test if f is within box
        0.upto(d-1) {|i| assert(box.lower[i] < f[i] && f[i] <= box.upper[i])}
      end
    end
    assert_equal([n]*levs, sum_each_level)
  end
  
end
