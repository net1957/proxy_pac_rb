require 'spec_helper'

describe 'Fetch proxy pac' do
  context '/v1/pac' do
    it 'finds an existing proxy pac' do
      create_file '.config/pacfiles/file1.pac', 'asdf'

      env = {
        'HOME' => working_directory,
      }

      with_environment env, clear: true do
        response = get('/v1/pac/file1.pac')
        expect(response.body).to eq('asdf')
      end
    end

    it 'exits with 404 if file does not exist' do
      response = get('/v1/pac/does_not_exist.pac')
      expect(response.body).to include('does_not_exist.pac')
    end
  end
end
