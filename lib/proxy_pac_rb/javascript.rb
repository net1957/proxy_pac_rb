# encoding: utf-8
# frozen_string_literal: true
module ProxyPacRb
  # Parse Proxy pac to file system
  class Javascript
    private

    attr_reader :context

    public

    def initialize(context)
      @context = context
    end

    # rubocop:disable Style/MethodMissing
    def method_missing(*args, &_block)
      context.call(args.shift, *args)
    end
    # rubocop:enable Style/MethodMissing
  end
end
