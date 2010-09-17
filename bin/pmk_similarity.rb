#!/usr/bin/env ruby

#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'pmk'
r = PMK::CLI::Similarity.new(ARGV)
r.run
