module Api
  module V1
    class AuthenticationController < ApplicationController
      def authenticate
        command = Api::V1::Auth::AuthenticateUser.call(params[:email], params[:password])

        if command.success?
          render json: { auth_token: command.result }
        else
          error_code = command.errors[:error_code].first
          render json: { error_code: error_code, message: Api::V1::Auth.to_s(error_code) }, status: :unauthorized
        end
      end
    end
  end
end
