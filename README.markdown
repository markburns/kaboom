# K A B O O M

## About

boom manages your text snippets. On the command line. I just blew your mind.
kaboom adds sharing snippets. On the command line.

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

## Contribute

Clone this repository, then run `bundle install`. That'll install all the gem
dependencies. Make sure that existing tests pass (`rake`), and that any new functionality
includes appropriate tests. Bonus points if you're not updating the gemspec or
bumping boom's version.

All good? Cool! Then send me a pull request
