# encoding: utf-8
require 'spec_helper'

describe ProxyPacRb::Functions do
  describe "isResolvable()" do
    it "should return true for localhost" do
      ProxyPacRb::Functions.isResolvable("localhost").must_equal true
    end

    it "should return false for awidhaowuhuiuhiuug" do
      ProxyPacRb::Functions.isResolvable("awidhaowuhuiuhiuug").must_equal false
    end
  end
end
