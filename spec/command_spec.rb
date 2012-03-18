require File.expand_path('spec/spec_helper')
require 'output_interceptor'

describe Boom::Command do
  before do
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

  it "use remote" do
    response = command('remote the_office fun awesome')

    assert_match /a new list called the_office/, response
    assert_match /fun in the_office is awesome/, response
  end

  it "remote checks for acceptable config" do
    response = command('remote the_office fun awesome')

    assert_match /a new list called the_office/, response
    assert_match /fun in the_office is awesome/, response
  end

  it "overview for empty" do
    storage = Boom::Storage
    storage.stubs(:lists).returns([])
    Boom::Command.stubs(:storage).returns(storage)
    assert_match /have anything yet!/, command(nil)
  end

  it "overview" do
    command(nil).should == '  urls (2)'
  end

  it "list detail" do
    assert_match /github/, command('urls')
  end

  it "list all" do
    cmd = command('all')
    assert_match /urls/,    cmd
    assert_match /github/,  cmd
  end

  it "list creation" do
    assert_match /a new list called newlist/, command('newlist')
  end

  it "list creation with item" do
    assert_match /a new list called newlist.* item in newlist/, command('newlist item blah')
  end

  it "list creation with item stdin" do
    STDIN.stubs(:read).returns('blah')
    STDIN.stubs(:stat)
    STDIN.stat.stubs(:size).returns(4)

    assert_match /a new list called newlist.* item in newlist is blah/, command('newlist item')
  end

  it "item access" do
    IO.stubs(:popen)
    assert_match /copied https:\/\/github\.com to your clipboard/,
      command('github')
  end

  it "item access scoped by list" do
    IO.stubs(:popen)
    assert_match /copied https:\/\/github\.com to your clipboard/,
      command('urls github')
  end

  it "item open item" do
    assert_match /opened https:\/\/github\.com for you/, command('open github')
  end

  it "item open specific item" do
    assert_match /opened https:\/\/github\.com for you/, command('open urls github')
  end

  it "item open lists" do
    assert_match /opened all of urls for you/, command('open urls')
  end

  it "item creation" do
    assert_match /twitter in urls/,
      command('urls twitter http://twitter.com/holman')
  end

  it "item creation long value" do
    assert_match /is tanqueray hendricks bombay/,
      command('urls gins tanqueray hendricks bombay')
  end

  it "list deletion no" do
    STDIN.stubs(:gets).returns('n')
    assert_match /Just kidding then/, command('urls delete')
  end

  it "list deletion yes" do
    STDIN.stubs(:gets).returns('y')
    assert_match /Deleted all your urls/, command('urls delete')
  end

  it "item deletion" do
    assert_match /github is gone forever/, command('urls github delete')
  end

  it "help" do
    assert_match 'boom help', command('help')
    assert_match 'boom help', command('-h')
    assert_match 'boom help', command('--help')
  end

  it "noop options" do
    assert_match 'boom help', command('--anything')
    assert_match 'boom help', command('-d')
  end

  it "nonexistent item access scoped by list" do
    assert_match /twitter not found in urls/, command('urls twitter')
  end

  it "echo item" do
    assert_match %r{https://github\.com}, command('echo github')
  end

  it "echo item shorthand" do
    assert_match %r{https://github\.com}, command('e github')
  end

  it "echo item does not exist" do
    assert_match /wrong.*not found/, command('echo wrong')
  end

  it "echo list item" do
    assert_match %r{https://github\.com}, command('echo urls github')
  end

  it "echo list item does not exist" do
    assert_match /wrong not found in urls/, command('echo urls wrong')
  end

  it "show storage" do
    Boom::Config.any_instance.stubs(:attributes).returns('backend' => 'json')
    assert_match /You're currently using json/, command('storage')
  end

  it "nonexistant storage switch" do
    Boom::Config.any_instance.stubs(:save).returns(true)
    assert_match /couldn't find that storage engine/, command('switch dkdkdk')
  end

  it "storage switch" do
    Boom::Config.any_instance.stubs(:save).returns(true)
    assert_match /We've switched you over to redis/, command('switch redis')
  end

  it "version switch" do
    assert_match /#{Boom::VERSION}/, command('-v')
  end

  it "version long" do
    assert_match /#{Boom::VERSION}/, command('--version')
  end

  it "stdin pipes" do
    stub = Object.new
    stub.stubs(:stat).returns([1,2])
    stub.stubs(:read).returns("http://twitter.com")
    Boom::Command.stubs(:stdin).returns(stub)
    assert_match /twitter in urls/, command('urls twitter')
  end

  it "random" do
    Boom::Config.any_instance.stubs(:save).returns(true)
    assert_match /opened .+ for you/, command('random')
  end

  it "random from list" do
    Boom::Config.any_instance.stubs(:save).returns(true)
    assert_match /(github|zachholman)/, command('random urls')
  end

  it "random list not exist" do
    Boom::Config.any_instance.stubs(:save).returns(true)
    assert_match /couldn't find that list\./, command('random 39jc02jlskjbbac9')
  end

  it "delete item list not exist" do
    assert_match /couldn't find that list\./, command('urlz github delete')
  end

  it "delete item wrong list" do
    command('urlz twitter https://twitter.com/')
    assert_match /github not found in urlz/, command('urlz github delete')
  end

  it "delete item different name" do
    command('foo bar baz')
    assert_match /bar is gone forever/, command('foo bar delete')
  end

  it "delete item same name" do
    command('duck duck goose')
    assert_match /duck is gone forever/, command('duck duck delete')
  end

end
