Feature: Init proxy pac

  As a proxy administrator
  I want to start a new proxy.pac
  In order to save some time

  Scenario: Non-existing proxy.pac
    Given a proxy.pac named "proxy" does not exist
    When I successfully run `pprb init proxy_pac`
    Then the proxy.pac "proxy" should contain:
    """
    function FindProxyForURL(url, host) {
      return "DIRECT";
    }
    """

  Scenario: Existing proxy.pac
    Given a proxy.pac named "proxy" with:
    """
    function FindProxyForURL(url, host) {
      return "DIRECT";
    }
    """
    When I run `pprb init proxy_pac` interactively
    And I type "y"
    And I close the stdin stream
    Then the output should contain:
    """
    Overwrite
    """

    @wip
  Scenario: Add skeleton rspec
    Given a proxy.pac named "proxy" does not exist
    When I successfully run `pprb init proxy_pac --test rspec`
    Then a file named "spec/spec_helper.rb" should exist
    Then a directory named "spec/support" should exist
    Then a file named "spec/support/aruba.rb" should exist
    Then a file named "spec/support/proxy_pac_rb.rb" should exist
    Then a file named "spec/support/rspec.rb" should exist
    Then a directory named "spec/support/shared_examples" should exist
    Then a directory named "spec/support/shared_contexts" should exist
    Then a directory named "spec/support/matchers" should exist

  Scenario: Add skeleton middleman
    Given a proxy.pac named "proxy" does not exist
    When I successfully run `pprb init proxy_pac --builder middleman`
    Then a file named "spec/spec_helper.rb" should exist
