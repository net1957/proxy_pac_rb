RSpec::Matchers.define :be_valid_option do |_|
  match do |actual|
    subject.option?(actual)
  end

  failure_message do |actual|
    format("expected that \"%s\" is a valid option", actual)
  end

  failure_message_when_negated do |actual|
    format("expected that \"%s\" is not a valid option", actual)
  end
end

RSpec::Matchers.define :have_option_value do |expected|
  match do |actual|
    values_match? subject.public_send(actual.to_sym), expected
  end

  failure_message do |actual|
    format(%(expected that option "%s" has value "%s"), actual, expected)
  end

  failure_message_when_negated do |actual|
    format(%(expected that option "%s" does not have value "%s"), actual, expected)
  end
end
