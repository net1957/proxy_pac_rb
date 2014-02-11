# LocalPac

Serve proxy.pac-files with ease.

## Installation

Add this line to your application's Gemfile:

    gem 'local_pac'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install local_pac

## Usage

You need to place your proxy.pac in one of the following directories:

* $HOME/.config/pacfiles/
* $HOME/.pacfiles/

Otherwise the gem will use it's default proxy.pac:

```javascript
function FindProxyForURL(url, host) {
  return "DIRECT";
}
```

After storing your proxy.pac-files you can serve them via:

```bash
local_pac serve

# Output:
# [2014-02-11 14:30:51] INFO  WEBrick 1.3.1
# [2014-02-11 14:30:51] INFO  ruby 1.9.3 (2013-11-22) [x86_64-linux]
# == Sinatra/1.4.4 has taken the stage on 8000 for development with backup from WEBrick
# [2014-02-11 14:30:51] INFO  WEBrick::HTTPServer#start: pid=2295 port=8000
```


After that you need to point your browser to your proxy.pac:

```
http://localhost:8000/v1/pac/<name>.pac
```


If you want to use it in a larger deployment, you might want to use the
systemd-files provided by the gem:

* share/system/local_pac.socket
* share/system/local_pac.service

## Reading

A good website to support you writing proxy.pac-files is:
http://findproxyforurl.com.

## Future

* Add feature: Compress proxy.pac-files before delivering them
* Improve API to support further functionality

## Contributing

1. Fork it ( http://github.com/<my-github-username>/local_pac/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
