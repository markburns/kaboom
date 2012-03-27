require File.expand_path('spec/spec_helper')
require 'output_interceptor'

describe Boom::Command do
  before do
    [Boom::Platform::Darwin, Boom::Platform::Linux,
     Boom::Platform::Windows].each do |klass|
      klass.any_instance.stubs('system')
     end
    IO.stub(:popen)
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

    response.should =~  /a new list called the_office/
    response.should =~  /fun in the_office is awesome/
  end

  it "remote checks for acceptable config" do
    response = command('remote the_office fun awesome')

    response.should =~  /a new list called the_office/
    response.should =~  /fun in the_office is awesome/
  end

  it "overview for empty" do
    storage = Boom::Storage
    storage.stubs(:lists).returns([])
    Boom::Command.stubs(:storage).returns(storage)
    command(nil).should =~  /have anything yet!/
  end

  it "overview" do
    debugger
    command(nil).should == '  urls (2)'
  end

  it "list detail" do
    command('urls').should =~  /github/
  end

  it "list all" do
    cmd = command('all')
    assert_match /urls/,    cmd
    assert_match /github/,  cmd
  end

  it "list creation" do
    command('newlist').should =~  /a new list called newlist/
  end

  it "list creation with item" do
    command('newlist item blah').should =~  /a new list called newlist.* item in newlist/
  end

  it "list creation with item stdin" do
    STDIN.stubs(:read).returns('blah')
    STDIN.stubs(:stat)
    STDIN.stat.stubs(:size).returns(4)

    command('newlist item').should =~  /a new list called newlist.* item in newlist is blah/
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
    command('open github').should =~  /opened https:\/\/github\.com for you/
  end

  it "item open specific item" do
    command('open urls github').should =~  /opened https:\/\/github\.com for you/
  end

  it "item open lists" do
    command('open urls').should =~  /opened all of urls for you/
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
    command('urls delete').should =~  /Just kidding then/
  end

  it "list deletion yes" do
    STDIN.stubs(:gets).returns('y')
    command('urls delete').should =~  /Deleted all your urls/
  end

  it "item deletion" do
    command('urls github delete').should =~  /github is gone forever/
  end

  it "help" do
    command('help').should =~  'boom help'
    command('-h').should =~  'boom help'
    command('--help').should =~  'boom help'
  end

  it "noop options" do
    command('--anything').should =~  'boom help'
    command('-d').should =~  'boom help'
  end

  it "nonexistent item access scoped by list" do
    command('urls twitter').should =~  /twitter not found in urls/
  end

  it "echo item" do
    command('echo github').should =~  %r{https://github\.com}
  end

  it "echo item shorthand" do
    command('e github').should =~  %r{https://github\.com}
  end

  it "echo item does not exist" do
    command('echo wrong').should =~  /wrong.*not found/
  end

  it "echo list item" do
    command('echo urls github').should =~  %r{https://github\.com}
  end

  it "echo list item does not exist" do
    command('echo urls wrong').should =~  /wrong not found in urls/
  end

  it "show storage" do
    Boom::Config.any_instance.stubs(:attributes).returns('backend' => 'json')
    command('storage').should =~  /You're currently using json/
  end

  it "nonexistant storage switch" do
    Boom::Config.any_instance.stubs(:save).returns(true)
    command('switch dkdkdk').should =~  /couldn't find that storage engine/
  end

  it "storage switch" do
    Boom::Config.any_instance.stubs(:save).returns(true)
    command('switch redis').should =~  /We've switched you over to redis/
  end

  it "version switch" do
    command('-v').should =~  /#{Boom::VERSION}/
  end

  it "version long" do
    command('--version').should =~  /#{Boom::VERSION}/
  end

  it "stdin pipes" do
    stdin = mock 'stdin', :stat => [1,2], :read => "http://twitter.com"
    Boom::Command.stub(:stdin).and_return stdin
    command('urls twitter').should =~  /twitter in urls/
  end

  it "random" do
    Boom::Config.any_instance.stubs(:save).returns(true)
    command('random').should =~  /opened .+ for you/
  end

  it "random from list" do
    Boom::Config.any_instance.stubs(:save).returns(true)
    command('random urls').should =~  /(github|zachholman)/
  end

  it "random list not exist" do
    Boom::Config.any_instance.stubs(:save).returns(true)
    command('random 39jc02jlskjbbac9').should =~  /couldn't find that list\./
  end

  it "delete item list not exist" do
    command('urlz github delete').should =~  /couldn't find that list\./
  end

  it "delete item wrong list" do
    command('urlz twitter https://twitter.com/')
    command('urlz github delete').should =~  /github not found in urlz/
  end

  it "delete item different name" do
    command('foo bar baz')
    command('foo bar delete').should =~  /bar is gone forever/
  end

  it "delete item same name" do
    command('duck duck goose')
    command('duck duck delete').should =~  /duck is gone forever/
  end

end
