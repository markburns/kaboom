require File.expand_path('spec/spec_helper')
require 'output_interceptor'

describe Remote do
  def dummy type
    m = stub 'storage_type', :class => type
  end

  it "remote" do
    Boom.use_remote false
    Boom::Output.capture_output

    local  = [Boom::Storage::Json, Boom::Storage::Keychain ]


    remote = [Boom::Storage::Gist, Boom::Storage::Mongodb, Boom::Storage::Redis]

    (local + remote).all? do |type|
      Boom::Remote.allowed? dummy(type).should.not == nil
    end

    Boom.use_remote true

    Boom::Remote.stubs(:output)
    remote.all? { |t| assert Boom::Remote.allowed?(dummy(t)), "#{t} should be allowed" }
    local.all?  { |t| assert !Boom::Remote.allowed?(dummy(t)), "#{t} should not be allowed"}
  end
end
