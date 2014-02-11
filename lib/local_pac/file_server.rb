module LocalPac
  class FileServer < Sinatra::Base
    not_found do
      "Sorry, but I cant' find proxy-pac-file \"#{env['sinatra.error'].message}\"."
    end

    get '/' do
      redirect to('/v1/pac/proxy.pac')
    end

    get '/v1/pac/:name' do
      manager = PacManager.new
      file = manager.find(params[:name])

      if file.nil?
        fail Sinatra::NotFound, params[:name]
      else
        file.content 
      end
    end
  end
end
