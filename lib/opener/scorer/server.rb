require 'sinatra'
require 'nokogiri'
require File.expand_path('../../../../config/database', __FILE__)

module Opener
  class Scorer
    class Server < Sinatra::Base

      post '/' do
        output            = Output.new
        output.uuid       = params[:request_id]
        output.text       = OutputProcessor.new(params[:input]).process.to_json
        output.save
      end

      get '/' do
        if params[:request_id]
          redirect "#{url("/")}#{params[:request_id]}"
        else
          erb :index
        end
      end

      get '/:request_id' do
        unless params[:request_id] == 'favicon.ico'
          begin
            output = Output.find_by_uuid(params[:request_id])

            if output
              content_type(:json)
              scores = JSON.parse(output.text)
              body( {:uuid=>output.uuid, :scores=>scores}.to_json)
            else
              halt(404, "No record found for ID #{params[:request_id]}")
            end
          rescue => error
            error_callback = params[:error_callback]

            submit_error(error_callback, error.message) if error_callback

            raise(error)
          end
        end
      end

      private

      def submit_error(url, message)
        HTTPClient.post(url, :body => {:error => message})
      end
    end # Server
  end # Scorer
end # Opener
