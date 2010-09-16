#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'test/unit'
require 'pmk'

module FeatureAssertions
  def assert_equal_features(a,b)
    assert_equal(a.length, b.length)
    for i in 0..a.length-1 do
      assert_equal(a[i], b[i])
    end
  end
  
  def assert_delta_features(a, b, delta=1e-10)
    assert_equal(a.length, b.length)
    for i in 0..a.length-1 do
      assert_in_delta(a[i], b[i])
    end
  end
end
