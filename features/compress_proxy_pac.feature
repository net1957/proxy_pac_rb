Feature: Compress proxy pac

  As a proxy administrator
  I want to compress a proxy pac
  In order to save some bandwidth

  Scenario: Existing proxy.pac.in
    Given a file named "proxy.pac.in" with:
    """
    function FindProxyForURL(url, host) {
      // comment
      return 'PROXY localhost:3128';
    }
    """
    When I successfully run `pprb compress pac_file -p proxy.pac.in`
    Then the file "proxy.pac" should contain:
    """
    function FindProxyForURL(url, host) {
        return "PROXY localhost:3128";
    }
    """

  Scenario: Existing proxy.pac
    Given a file named "proxy.pac" with:
    """
    function FindProxyForURL(url, host) {
      // comment
      return 'PROXY localhost:3128';
    }
    """
    When I successfully run `pprb compress pac_file -p proxy.pac`
    Then the file "proxy.pac.out" should contain:
    """
    function FindProxyForURL(url, host) {
        return "PROXY localhost:3128";
    }
    """

  Scenario: Checks for valid proxy pac
    Given a file named "proxy.pac.in" with:
    """
    $"§$"
    function FindProxyForURL(url, host) {
      return 'PROXY localhost:3128';
    }
    """
    When I run `pprb compress pac_file -p proxy.pac.in`
    Then the output should contain:
    """
    Unexpected string
    """

  Scenario: Use multiple proxy.pac.in
    Given a file named "proxy1.pac.in" with:
    """
    function FindProxyForURL(url, host) {
      // comment
      return 'PROXY localhost:3128';
    }
    """
    And a file named "proxy2.pac.in" with:
    """
    function FindProxyForURL(url, host) {
      // comment
      return 'PROXY localhost:3128';
    }
    """
    And a file named "proxy3.pac" with:
    """
    function FindProxyForURL(url, host) {
      // comment
      return 'PROXY localhost:3128';
    }
    """
    When I successfully run `pprb compress pac_file -p proxy1.pac.in proxy2.pac.in proxy3.pac`
    Then the file "proxy1.pac" should contain:
    """
    function FindProxyForURL(url, host) {
        return "PROXY localhost:3128";
    }
    """
    And the file "proxy2.pac" should contain:
    """
    function FindProxyForURL(url, host) {
        return "PROXY localhost:3128";
    }
    """
    And the file "proxy3.pac.out" should contain:
    """
    function FindProxyForURL(url, host) {
        return "PROXY localhost:3128";
    }
    """
