require 'opener/webservice'

module Opener
  class Scorer
    ##
    # Server for storing scorer data in MySQL.
    #
    class Server < Webservice::Server
      set :views, File.expand_path('../views', __FILE__)

      self.text_processor  = OutputProcessor
      self.accepted_params = [:input, :request_id]

      get '/' do
        if params[:request_id]
          redirect "#{url("/")}#{params[:request_id]}"
        else
          erb :index
        end
      end

      get '/:request_id' do
        unless params[:request_id] == 'favicon.ico'
          output = Output.find_by_uuid(params[:request_id])

          if output
            content_type(:json)

            scores = JSON.parse(output.text)

            body({:uuid=>output.uuid, :scores=>scores}.to_json)
          else
            halt(404, "No record found for ID #{params[:request_id]}")
          end
        end
      end
    end # Server
  end # Scorer
end # Opener
