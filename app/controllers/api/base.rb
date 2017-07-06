require 'grape-swagger'

module API
  class Base < Grape::API
    use ::WineBouncer::OAuth2
    mount API::V1::Base
    add_swagger_documentation api_version: "v1"

    route :any, '/api/*path' do
      error!({ error: 'Not Found', detail: "No such route '#{request.path}'", status: '404' }, 404, { 'Content-Type' => 'text/error' })
    end
  end
end
