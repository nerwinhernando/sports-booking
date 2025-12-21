module Api
  module V1
    class BaseController < ActionController::API
      include ActionController::HttpAuthentication::Token::ControllerMethods

      set_current_tenant_through_filter
      before_action :set_tenant
      before_action :authenticate_api_user!, except: [:login, :register]

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

      private

      def set_tenant
        subdomain = request.subdomain.presence

        if subdomain.present? && subdomain != 'www'
          account = Account.find_by(subdomain: subdomain)

          if account
            set_current_tenant(account)
          else
            render json: { error: 'Account not found' }, status: :not_found
            return
          end
        else
          render json: { error: 'Subdomain required for API access' }, status: :bad_request
          return
        end
      end

      def authenticate_api_user!
        authenticate_or_request_with_http_token do |token, options|
          @current_api_user = authenticate_token(token)
        end

        unless @current_api_user
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end

      def authenticate_token(token)
        begin
          decoded = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
          user_id = decoded[0]['user_id']
          account_id = decoded[0]['account_id']

          user = User.find_by(id: user_id, account_id: account_id)
          user if user && user.account_id == ActsAsTenant.current_tenant&.id
        rescue JWT::DecodeError, JWT::ExpiredSignature
          nil
        end
      end

      def current_api_user
        @current_api_user
      end

      def current_account
        ActsAsTenant.current_tenant
      end

      def not_found(exception)
        render json: { error: exception.message }, status: :not_found
      end

      def unprocessable_entity(exception)
        render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
