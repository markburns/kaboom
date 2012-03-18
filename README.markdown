# K A B O O M

## About

boom manages your text snippets. On the command line. I just blew your mind.

kaboom adds sharing snippets. On the command line.


This is a fork of Zach Holman's amazing boom. Explanation for the fork follows
a little later


For more details about what boom is and how it works, check out
[boom's website](http://holman.github.com/boom). For full usage details
(including a complete list of commands), check out
[boom's wiki](https://github.com/holman/boom/wiki).

## Install

    gem install kaboom

## Quick and Dirty

    $ boom gifs
    Boom! Created a new list called "gifs".

    $ boom gifs melissa http://cl.ly/3pAn/animated.gif
    Boom! "melissa" in "gifs" is "http://cl.ly/3pAn/animated.gif". Got it.

    $ boom melissa
    Boom! Just copied http://cl.ly/3pAn/animated.gif to your clipboard.

And that's just a taste! I know, you're salivating, I can hear you from here.
(Why your saliva is noisy is beyond me.) Check out the [full list of
commands](https://github.com/holman/boom/wiki/Commands).

## boom remote (or kaboom)
You can even have a remote boom using config in ~/.boom.remote.conf

    $ boom remote "a sandwich" cheese "mighty fine"
    Boom! cheese in a sandwich is mighty fine. Got it.

e.g. have a shared redis instance in the office for pinging around snippets to
each others command lines

    # me:
    $ kaboom config ackrc < ~/.ackrc

    # you:
    $ kaboom config ackrc > ~/.ackrc

## Distributed sharing of snippets with boom and kaboom
    # me:
    $ kaboom shared_links pivotal <  boom links pivotal

    $ you:
    $ kaboom shared_links pivotal >  boom links pivotal

## In Zach's words
  God it's about every day where I think to myself, gadzooks,
  I keep typing *REPETITIVE_BORING_TASK* over and over. Wouldn't it be great if
  I had something like boom to store all these commonly-used text snippets for
  me? Then I realized that was a worthless idea since boom hadn't been created
  yet and I had no idea what that statement meant. At some point I found the
  code for boom in a dark alleyway and released it under my own name because I
  wanted to look smart.

## Explanation for my fork
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


## Contribute

Clone this repository, then run `bundle install`. That'll install all the gem
dependencies. Make sure that existing tests pass (`rake`), and that any new functionality
includes appropriate tests. Bonus points if you're not updating the gemspec or
bumping boom's version.

All good? Cool! Then send me a pull request
