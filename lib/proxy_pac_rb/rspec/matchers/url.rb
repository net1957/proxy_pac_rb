RSpec::Matchers.define :be_downloaded_via do |expected|
  match do |actual|
    proxy_pac.find(actual) == expected
  end

  failure_message do |actual|
    format("expected that url \"%s\" is downloaded via \"%s\".", actual, expected)
  end

  failure_message_when_negated do |actual|
    format("expected that url \"%s\" is not downloaded via \"%s\".", actual, expected)
  end
end
