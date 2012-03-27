# coding: utf-8
require './lib/kaboom'
require 'test/unit'

begin
  require 'rubygems'
  require 'redgreen'
rescue LoadError
end

require 'mocha'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'kaboom'

def boom_json(name)
  root = File.expand_path(File.dirname(__FILE__))
  Boom::Storage::Json.any_instance.stub(:save).and_return(true)
  Boom::Storage::Json.any_instance.stub(:json_file).and_return("#{root}/examples/#{name}.json")
  Boom.use_remote false
  Boom.stub(:storage).and_return Boom::Storage::Json.new
end
