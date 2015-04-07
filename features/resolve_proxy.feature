Feature: Resolve proxy

  As a proxy administrator
  I want to resolve a proxy
  To check the proxy pac

  Scenario: Existing proxy.pac
    Given a file named "proxy.pac" with:
    """
    function FindProxyForURL(url, host) {
      return 'PROXY localhost:3128';
    }
    """
    When I successfully run `pprb find proxy -p proxy.pac -u www.example.org`
    Then the output should contain:
    """
    PROXY localhost:3128
    """

  Scenario: Existing proxy.pac with compressed content
    Given a file named "proxy.pac" with:
    """
    function FindProxyForURL(){return"PROXY localhost:3128"}
    """
    When I successfully run `pprb find proxy -p proxy.pac -u www.example.org`
    Then the output should contain:
    """
    PROXY localhost:3128
    """

  Scenario: Existing proxy.pac with relative path
    Given a file named "proxy.pac" with:
    """
    function FindProxyForURL(url, host) {
      return 'PROXY localhost:3128';
    }
    """
    When I successfully run `pprb find proxy -p ./proxy.pac -u www.example.org`
    Then the output should contain:
    """
    PROXY localhost:3128
    """

  Scenario: Existing proxy.pac with url
    Given a file named "proxy.pac" with:
    """
    function FindProxyForURL(url, host) {
      return 'PROXY localhost:3128';
    }
    """
    When I successfully run `pprb find proxy -p http://127.0.0.1:65535/proxy.pac -u www.example.org`
    Then the output should contain:
    """
    PROXY localhost:3128
    """

  Scenario: Non-Existing proxy.pac
    When I run `pprb find proxy -p proxy.pac -u www.example.org`
    Then the output should contain:
    """
    You need to provide a path to an existing proxy pac file. The file "proxy.pac" does not exist.
    """

  Scenario: Missing url
    Given a file named "proxy.pac" with:
    """
    function FindProxyForURL(url, host) {
      return 'PROXY localhost:3128';
    }
    """
    When I run `pprb find proxy -p proxy.pac`
    Then the output should contain:
    """
    No value provided for required options '--urls'
    """

  Scenario: Missing proxy parameter
    Given a file named "proxy.pac" with:
    """
    function FindProxyForURL(url, host) {
      return 'PROXY localhost:3128';
    }
    """
    When I run `pprb find proxy -u www.example.org`
    Then the output should contain:
    """
    No value provided for required options '--proxy-pac'
    """

  Scenario: Use client ip
    Given a file named "proxy.pac" with:
    """
    function FindProxyForURL(url, host) {
      if (isInNet(myIpAddress(), "10.0.0.0", "255.255.255.0")) {
        return 'PROXY localhost:3128';
      } else {
        return 'DIRECT';
      }
    }
    """
    When I successfully run `pprb find proxy -p proxy.pac -c 10.0.0.1 -u www.example.org`
    Then the output should contain:
    """
    PROXY localhost:3128
    """
    When I successfully run `pprb find proxy -p proxy.pac -c 192.0.0.1 -u www.example.org`
    Then the output should contain:
    """
    DIRECT
    """

  Scenario: Use time
    Given a file named "proxy.pac" with:
    """
    function FindProxyForURL(url, host) {
      if (dateRange("JAN", "MAY")) {
        return 'PROXY localhost:3128';
      } else {
        return 'DIRECT';
      }
    }
    """
    When I successfully run `pprb find proxy -p proxy.pac -t 2014-04-09 -u www.example.org`
    Then the output should contain:
    """
    PROXY localhost:3128
    """
    When I successfully run `pprb find proxy -p proxy.pac -t 2014-12-07 -u www.example.org`
    Then the output should contain:
    """
    DIRECT
    """

  Scenario: Unresolvable hostname
    Given a file named "proxy.pac" with:
    """
    function FindProxyForURL(url, host) {
      if (isInNet(dnsResolve(host), "8.8.8.8", "255.0.0.0")) {
        return 'PROXY localhost:3128';
      } else {
        return 'DIRECT';
      }
    }
    """
    When I successfully run `pprb find proxy -p proxy.pac -u unexist.localhost.localdomain`
    Then the output should contain:
    """
    DIRECT
    """

  Scenario: dnsResolve + isInNet
    Given a file named "proxy.pac" with:
    """
    function FindProxyForURL(url, host) {
      hostip = dnsResolve(host);
      if (isInNet(hostip, "127.0.0.1", "255.255.255.255") ||
          isInNet(hostip, "127.0.0.1", "255.255.255.255") ||
          isInNet(hostip, "127.0.0.1", "255.255.255.255") ||
          isInNet(hostip, "127.0.0.1", "255.255.255.255")) return 'proxy.example.com';
    }
    """
    When I successfully run `pprb find proxy -p proxy.pac -u http://localhost`
    Then the output should contain:
    """
    proxy.example.com
    """
