#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

require './test/test_helper.rb'

class MySubdivision < PMK::Subdivision
  def MySubdivision.create_node(id, box, features, level)
    PMK::Subdivision.new(:id => id, :box => box, :features => features, :level => level)
  end
end

class TestSubdivision < Test::Unit::TestCase
  include FeatureAssertions
  
  def test_node_data
    n = PMK::Subdivision.new(:x => 3, :y => 4)
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
    
    root = MySubdivision.generate(features, box, 2)
    assert_equal(0, root[:id])
    assert_equal_features([0.0, 0.0], root[:box].lower)
    assert_equal_features([1.0, 1.0], root[:box].upper)
    assert_equal(features, root[:features])
    assert_equal(3, root[:leaves].length)
    
    l0 = root[:leaves][0]
    assert_equal([0.0, 0.0], l0[:box].lower)
    assert_equal([0.5, 0.5], l0[:box].upper)
    assert_equal([[0.0, 0.0]], l0[:features])
    
    l1 = root[:leaves][1]
    assert_nil(l1)

    l2 = root[:leaves][2]
    assert_equal([0.0, 0.5], l2[:box].lower)
    assert_equal([0.5, 1.0], l2[:box].upper)
    assert_equal([[0.3, 0.7]], l2[:features])

    l3 = root[:leaves][3]
    assert_equal([0.5, 0.5], l3[:box].lower)
    assert_equal([1.0, 1.0], l3[:box].upper)
    assert_equal([[1.0, 1.0]], l3[:features])
    
  end
  
end
