# coding: utf-8

require 'helper'
require 'output_interceptor'

class TestCommand < Test::Unit::TestCase

  def setup
        [Boom::Platform::Darwin, Boom::Platform::Linux,
      Boom::Platform::Windows].each do |klass|
      klass.any_instance.stubs('system')
    end
        IO.stubs(:popen)
    boom_json :urls
  end

  def command(cmd)
    cmd = cmd.split(' ') if cmd
    Boom::Command.capture_output
    Boom::Command.execute(*cmd)
    output = Boom::Command.captured_output
    output.gsub(/\e\[\d\d?m/, '')
  end

  def test_use_remote
    response = command('remote the_office fun awesome')

    assert_match /a new list called the_office/, response
    assert_match /fun in the_office is awesome/, response
  end

  def test_remote_checks_for_acceptable_config
    response = command('remote the_office fun awesome')

    assert_match /a new list called the_office/, response
    assert_match /fun in the_office is awesome/, response
  end

  def test_overview_for_empty
    storage = Boom::Storage
    storage.stubs(:lists).returns([])
    Boom::Command.stubs(:storage).returns(storage)
    assert_match /have anything yet!/, command(nil)
  end

  def test_overview
    assert_equal '  urls (2)', command(nil)
  end

  def test_list_detail
    assert_match /github/, command('urls')
  end

  def test_list_all
    cmd = command('all')
    assert_match /urls/,    cmd
    assert_match /github/,  cmd
  end

  def test_list_creation
    assert_match /a new list called newlist/, command('newlist')
  end

  def test_list_creation_with_item
    assert_match /a new list called newlist.* item in newlist/, command('newlist item blah')
  end

  def test_list_creation_with_item_stdin
    STDIN.stubs(:read).returns('blah')
    STDIN.stubs(:stat)
    STDIN.stat.stubs(:size).returns(4)

    assert_match /a new list called newlist.* item in newlist is blah/, command('newlist item')
  end

  def test_item_access
    IO.stubs(:popen)
    assert_match /copied https:\/\/github\.com to your clipboard/,
      command('github')
  end

  def test_item_access_scoped_by_list
    IO.stubs(:popen)
    assert_match /copied https:\/\/github\.com to your clipboard/,
      command('urls github')
  end

  def test_item_open_item
    assert_match /opened https:\/\/github\.com for you/, command('open github')
  end

  def test_item_open_specific_item
    assert_match /opened https:\/\/github\.com for you/, command('open urls github')
  end

  def test_item_open_lists
    assert_match /opened all of urls for you/, command('open urls')
  end

  def test_item_creation
    assert_match /twitter in urls/,
      command('urls twitter http://twitter.com/holman')
  end

  def test_item_creation_long_value
    assert_match /is tanqueray hendricks bombay/,
      command('urls gins tanqueray hendricks bombay')
  end

  def test_list_deletion_no
    STDIN.stubs(:gets).returns('n')
    assert_match /Just kidding then/, command('urls delete')
  end

  def test_list_deletion_yes
    STDIN.stubs(:gets).returns('y')
    assert_match /Deleted all your urls/, command('urls delete')
  end

  def test_item_deletion
    assert_match /github is gone forever/, command('urls github delete')
  end

  def test_help
    assert_match 'boom help', command('help')
    assert_match 'boom help', command('-h')
    assert_match 'boom help', command('--help')
  end

  def test_noop_options
    assert_match 'boom help', command('--anything')
    assert_match 'boom help', command('-d')
  end

  def test_nonexistent_item_access_scoped_by_list
    assert_match /twitter not found in urls/, command('urls twitter')
  end

  def test_echo_item
    assert_match /https:\/\/github\.com/, command('echo github')
  end

  def test_echo_item_shorthand
    assert_match /https:\/\/github\.com/, command('e github')
  end

  def test_echo_item_does_not_exist
    assert_match /wrong not found/, command('echo wrong')
  end

  def test_echo_list_item
    assert_match /https:\/\/github\.com/, command('echo urls github')
  end

  def test_echo_list_item_does_not_exist
    assert_match /wrong not found in urls/, command('echo urls wrong')
  end

  def test_show_storage
    Boom::Config.any_instance.stubs(:attributes).returns('backend' => 'json')
    assert_match /You're currently using json/, command('storage')
  end

  def test_nonexistant_storage_switch
    Boom::Config.any_instance.stubs(:save).returns(true)
    assert_match /couldn't find that storage engine/, command('switch dkdkdk')
  end

  def test_storage_switch
    Boom::Config.any_instance.stubs(:save).returns(true)
    assert_match /We've switched you over to redis/, command('switch redis')
  end

  def test_version_switch
    assert_match /#{Boom::VERSION}/, command('-v')
  end

  def test_version_long
    assert_match /#{Boom::VERSION}/, command('--version')
  end
  def test_stdin_pipes
    stub = Object.new
    stub.stubs(:stat).returns([1,2])
    stub.stubs(:read).returns("http://twitter.com")
    Boom::Command.stubs(:stdin).returns(stub)
    assert_match /twitter in urls/, command('urls twitter')
  end

  def test_random
    Boom::Config.any_instance.stubs(:save).returns(true)
    assert_match /opened .+ for you/, command('random')
  end

  def test_random_from_list
    Boom::Config.any_instance.stubs(:save).returns(true)
    assert_match /(github|zachholman)/, command('random urls')
  end

  def test_random_list_not_exist
    Boom::Config.any_instance.stubs(:save).returns(true)
    assert_match /couldn't find that list\./, command('random 39jc02jlskjbbac9')
  end

  def test_delete_item_list_not_exist
    assert_match /couldn't find that list\./, command('urlz github delete')
  end

  def test_delete_item_wrong_list
    command('urlz twitter https://twitter.com/')
    assert_match /github not found in urlz/, command('urlz github delete')
  end

  def test_delete_item_different_name
    command('foo bar baz')
    assert_match /bar is gone forever/, command('foo bar delete')
  end

  def test_delete_item_same_name
    command('duck duck goose')
    assert_match /duck is gone forever/, command('duck duck delete')
  end

end
