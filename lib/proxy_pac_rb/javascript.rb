# encoding: utf-8
module ProxyPacRb
  # Parse Proxy pac to file system
  class Javascript
    private

    attr_reader :context

    public

    def initialize(context)
      @context = context
    end

    def method_missing(*args, &_block)
      context.call(args.shift, *args)
    end
  end
end
