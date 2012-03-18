require 'helper'

class TestPlatform < Test::Unit::TestCase
  def setup
    [Boom::Platform::Darwin, Boom::Platform::Linux,
      Boom::Platform::Windows].each do |klass|
      klass.any_instance.stubs('system')
    end
  end

  def test_darwin
    assert_equal Boom::Platform.platform.class,
      Boom::Platform::Darwin, RUBY_PLATFORM.include?('darwin')
  end

  def test_windows
    assert_equal Boom::Platform.platform.class,
      Boom::Platform::Windows if RUBY_PLATFORM =~ /mswin|mingw/
  end

  def test_linux
    assert_equal Boom::Platform.platform.class,
      Boom::Platform::Linux if RUBY_PLATFORM =~ /mswin|mingw/
  end

  def test_open_command_darwin
    assert_equal Boom::Platform::Darwin.new.open_command, 'open'
  end

  def test_open_command_windows
    assert_equal Boom::Platform::Windows.new.open_command, 'start'
  end

  def test_open_command_linux
    assert_equal Boom::Platform::Linux.new.open_command, 'xdg-open'
  end

  def test_copy_command_darwin
    assert_equal Boom::Platform::Darwin.new.copy_command, 'pbcopy'
  end

  def test_copy_command_windows
    assert_equal Boom::Platform::Windows.new.copy_command, 'clip'
  end

  def test_copy_command_linux
    assert_equal Boom::Platform::Linux.new.copy_command, 'xclip -selection clipboard'
  end

end
