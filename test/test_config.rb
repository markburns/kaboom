# coding: utf-8

require 'helper'
require 'output_interceptor'

class TestConfig < Test::Unit::TestCase

  before do
    Boom::Config.any_instance.stubs(:file).
      returns("test/examples/test_json.json")

    @config = Boom::Config.new
    @config.stubs(:save).returns(true)
  end

  it "bootstraps config" do
    @config.bootstrap
    @config.attributes.should == ({:backend => 'json'})
  end

  it "attributes" do
    @config.attributes[:wu_tang] = 'clan'
    @config.attributes[:wu_tang].should == 'clan'
  end


end
