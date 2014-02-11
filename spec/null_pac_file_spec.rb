# encoding: utf-8
require 'spec_helper'

describe NullPacFile do
  context '#path' do
    it 'always returns nil' do
      file = NullPacFile.new
      expect(file.path).to be_nil
    end
  end

  context '#name' do
    it 'always returns nil' do
      file = NullPacFile.new
      expect(file.name).to be_nil
    end
  end

  context '#content' do
    it 'returns the content of file' do
      file = NullPacFile.new
      expect(file.content).to be_nil
    end
  end

  context '#nil?' do
    it 'is always true' do
      file = NullPacFile.new
      expect(file.nil?).to be_true
    end
  end
end
