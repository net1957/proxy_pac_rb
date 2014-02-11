# encoding: utf-8
require 'spec_helper'

describe PacFile do
  context '#path' do
    it 'has a path' do
      file = PacFile.new('/usr/share/file1.pac')
      expect(file.path).to eq('/usr/share/file1.pac')
    end
  end

  context '#name' do
    it 'has a name' do
      file = PacFile.new('/usr/share/file1.pac')
      expect(file.name).to eq(:file1)
    end
  end

  context '#content' do
    it 'returns the content of file' do
      file = create_file('file1.pac', 'content')
      file = PacFile.new(file)
      expect(file.content).to eq('content')
    end
  end

  context '#nil?' do
    it 'is always false' do
      file = PacFile.new('/usr/share/file1.pac')
      expect(file.nil?).to be_false
    end
  end
end
