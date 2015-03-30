# Proxy Pac Rb

[![Build Status](https://travis-ci.org/fedux-org/proxy_pac_rb.png?branch=master)](https://travis-ci.org/fedux-org/proxy_pac_rb)
[![Code Climate](https://codeclimate.com/github/fedux-org/proxy_pac_rb.png)](https://codeclimate.com/github/fedux-org/proxy_pac_rb)
[![Coverage Status](https://coveralls.io/repos/fedux-org/proxy_pac_rb/badge.png?branch=master)](https://coveralls.io/r/fedux-org/proxy_pac_rb?branch=master)
[![Gem Version](https://badge.fury.io/rb/proxy_pac_rb.png)](http://badge.fury.io/rb/proxy_pac_rb)
[![Downloads](http://img.shields.io/gem/dt/proxy_pac_rb.svg?style=flat)](http://rubygems.org/gems/proxy_pac_rb)


`proxy_pac_rb` is a gem to parse [proxy auto-config](http://en.wikipedia.org/wiki/Proxy_auto-config) files.
`proxy_pac_rb` uses a JavaScript runtime to evaulate a proxy auto-config file the same way a browser does to determine what proxy (if
any at all) should a program use to connect to a server. You must install on of the supported JavaScript runtimes:
therubyracer, therubyrhino

Big thanks to [sstephenson](https://github.com/sstephenson)'s [execjs](https://github.com/sstephenson/execjs) for the
runtime wrapper code and to
[samuelkadolph](https://github.com/samuelkadolph/ruby-pac)'s
[ruby-pac](https://github.com/samuelkadolph/ruby-pac) for the foundation of this gem.

## Installing

Add this line to your application's Gemfile:

    gem 'proxy_pac_rb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install proxy_pac_rb


## Requirements

After installing the `proxy_pac_rb` gem you must install a JavaScript runtime. Compatible runtimes include:

* [therubyracer](https://rubygems.org/gems/therubyracer) Google V8 embedded within Ruby
* [therubyrhino](https://rubygems.org/gems/therubyrhino/) Mozilla Rhino embedded within JRuby

## Usage

### Command Line

#### Find proxy for url

*Arguments*

* `-p|--proxy-pac FILE`: Path to proxy pac file
* `-t|--time YYYY-MM-DD HH:MM:SS`: Time to use in proxy.pac
* `-c|--client-ip x.x.x.x`: Client-IP to use in proxy.pac
* `-h|--help`: Show help

*Use*

```bash
# Download pac
curl -L -o sample.pac https://github.com/fedux-org/proxy_pac_rb/raw/master/files/sample.pac

# Parse pac
pprb find proxy -c 127.0.0.1 -t "2014-03-09 12:00:00" -p sample.pac -u https://github.com

# =>                url: result
# => https://github.com: DIRECT
```

#### Compress proxy.pac-file

You can compress a proxy.pac with `pprb` to reduce the amount of data
transferred to download the proxy.pac.

```
# Download pac
curl -L -o sample.pac https://github.com/fedux-org/proxy_pac_rb/raw/master/files/sample.pac

# Compress pac
pprb compress proxy_pac -p sample.pac
```

#### Lint proxy.pac-file

You can lint a proxy.pac with `pprb` to check a proxy.pac before deploying it.

```
# Download pac
curl -L -o sample.pac https://github.com/fedux-org/proxy_pac_rb/raw/master/files/sample.pac

# Lint pac
pprb lint proxy_pac -p sample.pac
```

### Rack-based servers
```

*Warning*

The linter-`rack`-middleware needs to be activated before ANY other
middleman-extension, `rack`-middleware or whatever framework you are using
can instantiate the `V8`-runtime! Only the first time the
`V8`-javascript-engine - aka `therubyracer` - is instantiated, it is possible to
create a binding to ruby code. Every other `V8`-object created later re-uses
this binding.

You might an error like this if you ignore this warning!

```bash
error  build/proxy.pac
Unexpected token: name (is) (line: 1, col: 10, pos: 10)

Error
    at new JS_Parse_Error (<eval>:2359:10623)
    at js_error (<eval>:2359:10842)
    at croak (<eval>:2359:19086)
    at token_error (<eval>:2359:19223)
    at unexpected (<eval>:2359:19311)
    at semicolon (<eval>:2359:19784)
    at simple_statement (<eval>:2359:22580)
    at <eval>:2359:20553
    at <eval>:2359:19957
    at <eval>:2359:31968
There were errors during this build
```

*Linter Middleware*

```ruby
require 'proxy_pac_rb/rack/proxy_pac_linter'
use ProxyPacRb::Rack::ProxyPacLinter
```

*Compressor Middleware*

```ruby
require 'proxy_pac_rb/rack/proxy_pac_compressor'
use ProxyPacRb::Rack::ProxyPacCompressor

### Ruby

*Load from website*

```ruby
require 'proxy_pac_rb'

file = ProxyPacRb::Parser.new.load('https://github.com/fedux-org/proxy_pac_rb/raw/master/files/sample.pac')
file.find('https://github.com')        # => "DIRECT"
```

*Load from filesystem*

```bash
curl -L -o sample.pac https://github.com/fedux-org/proxy_pac_rb/raw/master/files/sample.pac
```

```ruby
require 'proxy_pac_rb'

file = ProxyPacRb::Parser.new.read("sample.pac")
file.find('https://github.com')        # => "DIRECT"
```

*Use string*

```ruby
require 'proxy_pac_rb'

file = ProxyPacRb::Parser.new.source <<-JS
  function FindProxyForURL(url, host) {
    return "DIRECT";
  }
JS

file.find('http://localhost') # => "DIRECT"
```

*Use Client IP*

```ruby
require 'proxy_pac_rb'

environment = ProxyPacRb::Environment.new(client_ip: '127.0.0.1')
file = ProxyPacRb::Parser.new(environment).load('https://github.com/fedux-org/proxy_pac_rb/raw/master/files/sample2.pac')
file.find('https://github.com')        # => "PROXY localhost:8080"

environment = ProxyPacRb::Environment.new(client_ip: '127.0.0.2')
file = ProxyPacRb::Parser.new(environment).load('https://github.com/fedux-org/proxy_pac_rb/raw/master/files/sample2.pac')
file.find('https://github.com')        # => "DIRECT"
```

*Use Date Time*

```ruby
require 'proxy_pac_rb'

string = <<-EOS
function FindProxyForURL(url, host) {
  if (dateRange("JUL", "SEP")) {
    return "PROXY localhost:8080";                                                                                                          
  } else {
    return "DIRECT";
  }
}
EOS

environment = ProxyPacRb::Environment.new(time: Time.parse('2014-07-06 12:00'))
file = ProxyPacRb::Parser.new(environment).source(string)
file.find('http://localhost') # => 'PROXY localhost:8080'

environment = ProxyPacRb::Environment.new(time: Time.parse('2014-03-08 6:00'))
file = ProxyPacRb::Parser.new(environment).source(string)
file.find('http://localhost') # => 'DIRECT'
```

## Available JavaScript Functions

* isPlainHostName(host)
* dnsDomainIs(host, domain)
* localHostOrDomainIs(host, hostdom)
* isResolvable(host)
* isInNet(host, pattern, mask)
* dnsResolve(host)
* myIpAddress()
* dnsDomainLevels(host)
* shExpMatch(str, shexp)
* weekdayRange(wd1, wd2, gmt)
* dateRange(*args)
* timeRange(*args)
* alert(msg) (output on stderr by default)

## Developers

### Contributing

If you want to contribute: fork, branch & pull request.

### Running Tests

```
bundle install
rake test:rspec
rake test:rubyracer
rake test:rubyrhino
```

If you want to open an issue. Please send a PR with a test describing the bug.

