require 'rubygems' rescue LoadError
require 'test/spec'
require 'mocha'

$:.unshift(File.expand_path('../../lib', __FILE__))
require 'test/spec/rails'