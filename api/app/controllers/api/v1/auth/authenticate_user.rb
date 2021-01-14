module Api
  module V1
    module Auth
      class AuthenticateUser
        prepend SimpleCommand

        def initialize(email, password)
          @email = email
          @password = password
        end

        def call
          JsonWebToken.encode(user_id: user.id) if user
        end

        private

        attr_accessor :email, :password

        def user
          user = User.find_by_email(email)
          return user if user&.authenticate(password)

          errors.add :error_code, Api::V1::Auth::INVALID_CREDENTIALS
        end
      end
    end
  end
end
