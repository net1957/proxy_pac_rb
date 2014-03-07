# encoding: utf-8
require 'spec_helper'

describe ProxyPacRb::Functions do
  describe "isResolvable()" do
    let(:tester) do
      ProxyPacRb::Functions
    end

    it "should return true for localhost" do
      expect(tester.isResolvable("localhost")).to be_true
    end

    it "should return false for awidhaowuhuiuhiuug" do
      expect(tester.isResolvable('asdfasdfasdfasdf')).to be_false
    end
  end
end
