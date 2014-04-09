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
    When I successfully run `pprb -p proxy.pac www.example.org`
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
    When I successfully run `pprb -p ./proxy.pac www.example.org`
    Then the output should contain:
    """
    PROXY localhost:3128
    """

  Scenario: Non-Existing proxy.pac
    When I run `pprb -p proxy.pac www.example.org`
    Then the output should contain:
    """
    No such file or directory
    """

  Scenario: Missing url
    Given a file named "proxy.pac" with:
    """
    function FindProxyForURL(url, host) {
      return 'PROXY localhost:3128';
    }
    """
    When I run `pprb -p proxy.pac`
    Then the output should contain:
    """
    You need to provide at least one url
    """

  Scenario: Missing proxy parameter
    Given a file named "proxy.pac" with:
    """
    function FindProxyForURL(url, host) {
      return 'PROXY localhost:3128';
    }
    """
    When I run `pprb www.example.org`
    Then the output should contain:
    """
    You need to provide a proxy pac file
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
    When I successfully run `pprb -p proxy.pac -c 10.0.0.1 www.example.org`
    Then the output should contain:
    """
    PROXY localhost:3128
    """
    When I successfully run `pprb -p proxy.pac -c 192.0.0.1 www.example.org`
    Then the output should contain:
    """
    DIRECT
    """
