# frozen_string_literal: true
require 'proxy_pac_rb'

RSpec::Matchers.define :be_downloaded_via do |expected|
  match do |actual|
    @old_actual = actual
    @actual = proxy_pac.find(actual).to_s

    values_match? expected, @actual
  end

  failure_message do
    format(%(expected that url "%s" is downloaded via "%s", but it is downloaded via "%s".), @old_actual, expected, @actual)
  end

  failure_message_when_negated do
    format(%(expected that url "%s" is not downloaded via "%s", but it is downloaded via "%s".), @old_actual, expected, @actual)
  end
end
