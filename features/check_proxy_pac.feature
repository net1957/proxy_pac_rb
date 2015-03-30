Feature: Lint proxy pac

  As a proxy administrator
  I want to compress a proxy pac
  In order to save some bandwidth

  Scenario: Valid proxy.pac
    Given a file named "proxy.pac" with:
    """
    function FindProxyForURL(url, host) {
      return 'PROXY localhost:3128';
    }
    """
    When I successfully run `pprb lint pac_file -p proxy.pac`
    Then the output should contain:
    """
    proxy.pac "proxy.pac" is of type file and is valid
    """

  Scenario: Invalid proxy.pac
    Given a file named "proxy.pac" with:
    """
    function FindProxyForURL(url, host) {
      return $"§$ 'PROXY localhost:3128';
    }
    """
    When I run `pprb lint pac_file -p proxy.pac`
    Then the output should contain:
    """
    proxy.pac "proxy.pac" is of type file and is invalid
    """
