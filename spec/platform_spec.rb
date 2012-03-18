require File.expand_path('spec/spec_helper')

describe Boom::Platform do
  before do
    [Boom::Platform::Darwin, Boom::Platform::Linux,
      Boom::Platform::Windows].each do |klass|
      klass.any_instance.stubs('system')
    end
  end

  it "darwin" do
    assert_equal Boom::Platform.platform.class,
      Boom::Platform::Darwin, RUBY_PLATFORM.include?('darwin')
  end

  it "windows" do
    assert_equal Boom::Platform.platform.class,
      Boom::Platform::Windows if RUBY_PLATFORM =~ /mswin|mingw/
  end

  it "linux" do
    assert_equal Boom::Platform.platform.class,
      Boom::Platform::Linux if RUBY_PLATFORM =~ /mswin|mingw/
  end

  it "open command darwin" do
    'open'.should == Boom::Platform::Darwin.new.open_command
  end

  it "open command windows" do
    'start'.should == Boom::Platform::Windows.new.open_command
  end

  it "open command linux" do
    'xdg-open'.should == Boom::Platform::Linux.new.open_command
  end

  it "copy command darwin" do
    'pbcopy'.should == Boom::Platform::Darwin.new.copy_command
  end

  it "copy command windows" do
    'clip'.should == Boom::Platform::Windows.new.copy_command
  end

  it "copy command linux" do
    'xclip -selection clipboard'.should == Boom::Platform::Linux.new.copy_command
  end

end
