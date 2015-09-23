# Sticks::Pipe

Provides ready-to-use `Proc`s for I/O operations on `open3` to use in ruby applications such as interactive CLIs and log streaming.

## Installation

Add this line to your application's Gemfile:

    gem 'sticks-pipe'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sticks-pipe

## Usage

Let's say you like to interact with docker containers from your ruby app, here is several examples;

- Streaming logs
```
require 'sticks/pipes'
include Sticks::Pipe
pipe "docker logs -f 7117ef4de9f9", &Blocks.stream
2015-09-22 13:28:49,146 INFO supervisord started with pid 12
2015-09-22 13:28:50,213 INFO spawned: 'web' with pid 15
2015-09-22 13:28:50,559 DEBG 'web' stdout output:
Node app is running at localhost:5000

2015-09-22 13:28:51,561 INFO success: web entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
# process stays up and feeds the stream until you hit ctrl+c
```

- interactive tty

```
require 'sticks/pipes'
include Sticks::Pipe
```
pipe " docker run --rm -a stdout -a stderr -i -a stdin dokku/actn.io:latest /bin/bash", &Blocks.interactive
> ls
> app
> bin
> boot
> build
> cache
> dev
> etc
> exec
> home
> lib
> lib64
> media
> mnt
> opt
> proc
> root
> run
> sbin
> srv
> start
> sys
> tmp
> usr
> var
> exit
=> #<Process::Status: pid 28101 exit 0>
## Contributing

1. Fork it ( http://github.com/<my-github-username>/sticks-pipe/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
