# frozen_string_literal: true
require 'spec_helper'

RSpec.describe ProxyPacRb, type: :proxy_pac do
  context 'when use_proxy is true', use_proxy: true do
    it { expect(@proxy_pac_rb_config.use_proxy).to be true }
  end

  context 'when use_proxy is false', use_proxy: false do
    it { expect(@proxy_pac_rb_config.use_proxy).to be false }
  end
end
