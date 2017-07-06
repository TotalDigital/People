require 'doorkeeper/grape/helpers'

module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do

        before do
          header['Access-Control-Allow-Origin']   = '*'
          header['Access-Control-Request-Method'] = '*'
        end

        prefix "api"
        version "v1", using: :path
        content_type :json, 'application/json; charset=utf-8'
        default_format :json
        format :json
        formatter :json, Grape::Formatter::ActiveModelSerializers

        # Pagination settings
        @per_page     = 20
        @max_per_page = 100

        helpers Doorkeeper::Grape::Helpers
        helpers Pundit
        helpers do
          def permitted_params
            @permitted_params ||= declared(params, include_missing: false)
          end

          def current_token
            doorkeeper_access_token
          end

          def current_user
            resource_owner
          end

          def current_scopes
            current_token.scopes
          end

          def pundit_user
            ApplicationPolicy::UserContext.new(current_user, true)
          end

          def api_error(err_code, err_msg = nil)
            unless err_msg.present?
              err_msg = case err_code
                          when 404
                            'Record not found'
                          when 401
                            'Not authorized'
                          when 409
                            'Record invalid'
                          else
                            'An error occured'
                        end
            end
            error!({ error: err_msg, status: err_code }, err_code)
          end

          def create_resource(record)
            if record.valid?
              if Object.const_get("#{record.class.name.classify}Policy").new(pundit_user, record).create?
                record.save! && record
              else
                api_error 401
              end
            else
              api_error 409
            end
          end

          def update_resource(record, params)
            if Object.const_get("#{record.class.name.classify}Policy").new(pundit_user, record).update?
              record.update!(params) && record
            else
              api_error 401
            end
          end

          def delete_resource(record)
            if Object.const_get("#{record.class.name.classify}Policy").new(pundit_user, record).destroy?
              record.destroy!
            else
              api_error 401
            end
          end
        end

        rescue_from ActiveRecord::RecordNotFound do |e|
          api_error 404
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          api_error 409, e.message
        end

        rescue_from WineBouncer::Errors::OAuthUnauthorizedError do |e|
          api_error 401, e.message
        end

        rescue_from WineBouncer::Errors::OAuthForbiddenError do |e|
          api_error 403, e.message
        end

        rescue_from :all do |e|
          api_error 500, "Internal Server Error: #{e.message}"
        end
      end
    end
  end
end
