Feature: Compress proxy pac

  As a proxy administrator
  I want to compress a proxy pac
  In order to save some bandwidth

  Scenario: Existing proxy.pac.in
    Given a file named "proxy.pac.in" with:
    """
    function FindProxyForURL(url, host) {
      return 'PROXY localhost:3128';
    }
    """
    When I successfully run `pprb compress pac_file -p proxy.pac`
    Then the file "proxy.pac" should contain:
    """
    PROXY localhost:3128
    """
