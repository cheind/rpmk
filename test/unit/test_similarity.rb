#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

require './test/test_helper.rb'

class TestSimilarity < Test::Unit::TestCase
  include FeatureAssertions
  
  def test_similarity
    box = PMK::Box.new([0.0, 0.0], [1.0, 1.0])
    features = [[0.0, 0.0], [1.0, 1.0], [0.3, 0.7]]
    root = PMK::Subdivision.new(
      PMK::SubdivisionController.new(:nlevels => 3)
    ).generate(features, box)
    levels_root = PMK::PyramideView.new(:nlevels => 3, :ndims => 2).generate(root)
    
    assert_equal(features.length, PMK.similarity(levels_root, levels_root))
    assert_equal(features.length, PMK.similarity(levels_root, levels_root, :nlevels => 2))
    assert_equal(features.length, PMK.similarity(levels_root, levels_root, :nlevels => 1))
  end
  
  def test_normed_similarity
    box = PMK::Box.new([0.0, 0.0], [1.0, 1.0])
    features = [[0.0, 0.0], [1.0, 1.0], [0.3, 0.7]]
    root = PMK::Subdivision.new(
      PMK::SubdivisionController.new(:nlevels => 3)
    ).generate(features, box)
    levels_root = PMK::PyramideView.new(:nlevels => 3, :ndims => 2).generate(root)
    
    assert_equal(1.0, PMK.similarity_normed(levels_root, levels_root))
    assert_equal(1.0, PMK.similarity_normed(levels_root, levels_root, :nlevels => 2))
    assert_equal(1.0, PMK.similarity_normed(levels_root, levels_root, :nlevels => 1))
  end
  
  def test_normed_similarity_random
    n = 100
    d = 10
    levs = 10
    
    #box = PMK::Box.new([-0.5]*d, [1.5]*d)
    box = PMK::Box.new([-0.5]*d, [1.5]*d)
    box.lower.map! {|e| e - 0.5 + rand()*1.0}
    box.upper.map! {|e| e - 0.5 + rand()*1.0}
    
    subdiv = PMK::Subdivision.new(PMK::SubdivisionController.new(:nlevels => levs))
    pyr = PMK::PyramideView.new(:nlevels => levs, :ndims => d)
    
    srand(10)
    f_a = Array.new(n) {Array.new(d){rand()}}   
    f_b = f_a.map {|f| f.map {|e| e + rand()*0.001} }
    puts ""
    
    pv_a = pyr.generate(subdiv.generate(f_a, box))
    pv_b = pyr.generate(subdiv.generate(f_b, box))
    
    puts PMK.similarity_normed(pv_a, pv_b)
  end
  
  
end
