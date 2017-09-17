require 'rubygems'
require 'pathname'
PROJECT_ROOT = Pathname.new(File.dirname(File.dirname(File.expand_path(__FILE__))))
$LOAD_PATH.unshift(PROJECT_ROOT.join('lib'))
