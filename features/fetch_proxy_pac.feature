Feature: Fetch proxy pac

  As a proxy user
  I want to have a local proxy pac
  In order to reach different proxy servers

  Scenario: Default
    Given an empty environment
    When I sucessfully fetch the proxy pac
    Then I got
    """
    function FindProxyForURL(url, host) {
    }
    """
