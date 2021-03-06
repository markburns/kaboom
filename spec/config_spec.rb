require File.expand_path('spec/spec_helper')
require 'output_interceptor'

describe Boom::Config do
  before do
    Boom::Config.any_instance.stubs(:file).
      returns("test/examples/test_json.json")

    @config = Boom::Config.new
    @config.stubs(:save).returns(true)
  end

  it "bootstraps config" do
    @config.bootstrap
    @config.should == ({:backend => 'json'})
  end

  it "attributes" do
    @config[:wu_tang] = 'clan'
    @config[:wu_tang].should == 'clan'
  end


end
