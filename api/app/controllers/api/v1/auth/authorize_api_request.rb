module Api
  module V1
    module Auth
      class AuthorizeApiRequest
        prepend SimpleCommand

        def initialize(headers = {})
          @headers = headers
        end

        def call
          user
        end

        private

        attr_reader :headers

        def user
          @user ||= if Api::V1::Auth.has?(decoded_auth_token)
                      errors.add :error_code, decoded_auth_token
                      decoded_auth_token
                    elsif decoded_auth_token
                      User.find(decoded_auth_token[:user_id])
                    end
        end

        def decoded_auth_token
          return Api::V1::Auth::MISSING_TOKEN unless http_auth_header

          @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
        end

        def http_auth_header
          headers['Authorization'].split(' ').last if headers['Authorization'].present?
        end
      end
    end
  end
end
