# Proxy Pac Rb

[![Build Status](https://travis-ci.org/dg-ratiodata/proxy_pac_rb.png?branch=master)](https://travis-ci.org/dg-ratiodata/proxy_pac_rb)
[![Code Climate](https://codeclimate.com/github/dg-ratiodata/proxy_pac_rb.png)](https://codeclimate.com/github/dg-ratiodata/proxy_pac_rb)
[![Coverage Status](https://coveralls.io/repos/dg-ratiodata/proxy_pac_rb/badge.png?branch=master)](https://coveralls.io/r/dg-ratiodata/proxy_pac_rb?branch=master)
[![Gem Version](https://badge.fury.io/rb/proxy_pac_rb.png)](http://badge.fury.io/rb/proxy_pac_rb)

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

```
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

# Parse pac
pprb compress proxy_pac -p sample.pac

# =>                url: result
# => https://github.com: DIRECT
```

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

