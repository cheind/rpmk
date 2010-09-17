#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

#
# PMK - Ruby Pyramide Match Kernel Library
#
module PMK
  # Current version of PMK
  VERSION = '0.2'
end

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'pmk/box'
require 'pmk/subdivision'
require 'pmk/subdivision_controller'
require 'pmk/pyramide_view'
require 'pmk/similarity'
require 'pmk/io'
require 'pmk/cli_prepare'
require 'pmk/cli_similarity'


