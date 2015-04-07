RSpec::Matchers.define :be_the_same_proxy_pac_file do |expected|
  define_method :loader do
    ProxyPacRb::ProxyPacLoader.new
  end

  match do |actual|
    @file_a = ProxyPacRb::ProxyPacFile.new(source: actual)
    loader.load(@file_a)

    @file_b = ProxyPacRb::ProxyPacFile.new(source: expected)
    loader.load(@file_b)

    @file_a == @file_b
  end

  failure_message do
    format(%(expected that proxy.pac "%s" is equal to proxy.pac "%s", but it is not equal.\n\nActual:\n%s\n\nExpected:\n%s), @file_a.source, @file_b.source, @file_a.content, @file_b.content)
  end

  failure_message_when_negated do
    format(%(expected that proxy.pac "%s" is not equal to proxy.pac "%s", but it is equal.\n\nActual:\n%s\n\nExpected:\n%s), @file_a.source, @file_b.source, @file_a.content, @file_b.content)
  end
end
