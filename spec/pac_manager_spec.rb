# encoding: utf-8
require 'spec_helper'

describe PacManager do
  context '#find' do
    it 'finds the file in given path' do
      directory = create_directory 'pac_files'
      file_path = create_file 'pac_files/file1.pac'
      create_file 'pac_files/file2.pac'

      manager = PacManager.new(directory)
      file = manager.find('file1')
      expect(file.path).to eq(file_path)
    end

    it 'returs a null object if cannot be found' do
      manager = PacManager.new('/tmp')
      file = manager.find('file1')
      expect(file.nil?).to be_true
    end
  end
end
