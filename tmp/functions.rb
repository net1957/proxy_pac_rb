
      expect(file.find('http://localhost')).to eq('PROXY localhost:8080')
      expect(file.find('http://localhost')).to eq('DIRECT')
    end

    it 'respects time' do
      javascript = double('javascript')
      file = ProxyPacRb::File.new(javascript)

      expect(file.find('http://localhost', time: '2014-03-07 12:00:00')).to eq('PROXY localhost:8080')
      expect(file.find('http://localhost', time: '2014-03-07 19:00:00')).to eq('DIRECT')
