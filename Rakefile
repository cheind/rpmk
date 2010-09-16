#
# RPMK - Ruby Pyramide Match Kernel Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rpmk
#

require 'lib/pmk'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

task :default => ['test:unit:all']

namespace 'test' do

  namespace 'unit' do
  
    desc 'Run all unit tests'
    Rake::TestTask.new('all') do |t|
      t.pattern = FileList['test/unit/**/*.rb']
      t.verbose = false
      t.warning = false
    end
    
  end
end

namespace 'docs' do

  desc "Generate rdoc documentation"
  Rake::RDocTask.new do |rd|
    rd.rdoc_dir = "doc"
    rd.rdoc_files.include('README.md', 'LICENSE.md', 'lib/**/*.rb', 'examples/**/*.rb')
  end
  
  begin
    require 'yard'
    YARD::Rake::YardocTask.new do |t|
      t.files   = ['lib/**/*.rb', 'examples/**/*.rb', '-', 'LICENSE.md'] 
      t.options = ['--no-cache', '--title', "RPMK #{PMK::VERSION} Documentation"]
    end
  rescue LoadError
    warn '**YARD is missing, disabling docs:yard task'
  end
end
