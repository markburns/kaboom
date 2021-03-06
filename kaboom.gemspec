## This is the rakegem gemspec template. Make sure you read and understand
## all of the comments. Some sections require modification, and others can
## be deleted if you don't need them. Once you understand the contents of
## this file, feel free to delete any comments that begin with two hash marks.
## You can find comprehensive Gem::Specification documentation, at
## http://docs.rubygems.org/read/chapter/20
Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  ## Leave these as is they will be modified for you by the rake gemspec task.
  ## If your rubyforge_project name is different, then edit it and comment out
  ## the sub! line in the Rakefile
  s.name              = 'kaboom'
  s.version           = '0.3.3'
  s.date              = '2012-03-18'
  s.rubyforge_project = 'boom'

  ## Make sure your summary is short. The description may be as long
  ## as you like.
  s.summary     = "kaboom for accessing/share text snippets on the command line"

  s.description = "This is a fork of Zach Holman's amazing boom. Explanation for
  the fork follows Zach's intro to boom:

  God it's about every day where I think to myself, gadzooks,
  I keep typing *REPETITIVE_BORING_TASK* over and over. Wouldn't it be great if
  I had something like boom to store all these commonly-used text snippets for
  me? Then I realized that was a worthless idea since boom hadn't been created
  yet and I had no idea what that statement meant. At some point I found the
  code for boom in a dark alleyway and released it under my own name because I
  wanted to look smart.

  Explanation for my fork:

  Zach didn't fancy changing boom a great deal to handle the case of remote and
  local boom repos. Which is fair enough I believe in simplicity.
  But I also believe in getting tools to do what you want them to do.
  So with boom, you can change your storage with a 'boom storage' command, but
  that's a hassle when you want to share stuff.

  So kaboom does what boom does plus simplifies maintaining two boom repos.
  What this means is that you can pipe input between remote and local boom
  instances. My use case is to have a redis server in our office and be able
  to share snippets between each other, but to also be able to have personal
  repos.

  It's basically something like distributed key-value stores. I imagine some of
  the things that might be worth thinking about, based on DVC are:

  Imports/Exports of lists/keys/values between repos.
  Merge conflict resolution
  Users/Permissions/Teams/Roles etc
  Enterprisey XML backend
  I'm kidding

  No, but seriously I think I might allow import/export of lists and whole repos
  so that we can all easily back stuff up

  E.g.
  clone the whole shared repo
  backup your local repo to the central one underneath a namespace
  "



  ## List the primary authors. If there are a bunch of authors, it's probably
  ## better to set the email to an email list or something. If you don't have
  ## a custom homepage, consider using your GitHub URL or the like.
  s.authors  = ["Zach Holman", "Mark Burns"]
  s.email    = 'markthedeveloper@gmail.com'
  s.homepage = 'https://github.com/markburns/kaboom'

  ## This gets added to the $LOAD_PATH so that 'lib/NAME.rb' can be required as
  ## require 'NAME.rb' or'/lib/NAME/file.rb' can be as require 'NAME/file.rb'
  s.require_paths = %w[lib]

  ## This sections is only necessary if you have C extensions.
  #s.require_paths << 'ext'
  #s.extensions = %w[ext/extconf.rb]

  ## If your gem includes any executables, list them here.
  s.executables = ["boom", "kaboom"]
  s.default_executable = 'boom'

  ## Specify any RDoc options here. You'll want to add your README and
  ## LICENSE files to the extra_rdoc_files list.
  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.markdown LICENSE.markdown]

  ## List your runtime dependencies here. Runtime dependencies are those
  ## that are needed for an end user to actually USE your code.
  s.add_dependency('multi_json', "~> 1.0.3")
  s.add_dependency('json_pure', "~> 1.5.3")
  s.add_dependency('active_support')

  ## List your development dependencies here. Development dependencies are
  ## those that are only needed during development
  s.add_development_dependency('mocha', "~> 0.9.9")
  s.add_development_dependency('rake', "~> 0.9.2")

  ## Leave this section as-is. It will be automatically generated from the
  ## contents of your Git repository via the gemspec task. DO NOT REMOVE
  ## THE MANIFEST COMMENTS, they are used as delimiters by the task.
  # = MANIFEST =
  s.files = %w[
    CHANGELOG.markdown
    Gemfile
    Gemfile.lock
    LICENSE.markdown
    README.markdown
    Rakefile
    bin/boom
    bin/kaboom
    completion/README.md
    completion/boom.bash
    completion/boom.zsh
    kaboom.gemspec
    lib/kaboom.rb
    lib/kaboom/color.rb
    lib/kaboom/command.rb
    lib/kaboom/config.rb
    lib/kaboom/core_ext/symbol.rb
    lib/kaboom/item.rb
    lib/kaboom/list.rb
    lib/kaboom/output.rb
    lib/kaboom/platform.rb
    lib/kaboom/platform/base.rb
    lib/kaboom/platform/darwin.rb
    lib/kaboom/platform/linux.rb
    lib/kaboom/platform/windows.rb
    lib/kaboom/remote.rb
    lib/kaboom/storage.rb
    lib/kaboom/storage/base.rb
    lib/kaboom/storage/gist.rb
    lib/kaboom/storage/json.rb
    lib/kaboom/storage/keychain.rb
    lib/kaboom/storage/mongodb.rb
    lib/kaboom/storage/redis.rb
    test/examples/config_json.json
    test/examples/test_json.json
    test/examples/urls.json
    test/helper.rb
    test/output_interceptor.rb
    test/test_color.rb
    test/test_command.rb
    test/test_config.rb
    test/test_item.rb
    test/test_list.rb
    test/test_platform.rb
    test/test_remote.rb
  ]
  # = MANIFEST =

  ## Test files will be grabbed from the file list. Make sure the path glob
  ## matches what you actually use.
  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end
