module Api
  module V1
    module Auth
      extend BaseEnum

      NOT_AUTHORIZED = 1
      EXPIRED_TOKEN = 2
      INVALID_TOKEN = 3
      MISSING_TOKEN = 4
      INVALID_CREDENTIALS = 5

      @map = {
        NOT_AUTHORIZED => 'Not Authorized',
        EXPIRED_TOKEN => 'Token Expired',
        INVALID_TOKEN => 'Token is invalid',
        MISSING_TOKEN => 'Token is missing. Please include the token in the authorization header.',
        INVALID_CREDENTIALS => 'Invalid Credentials'
      }.freeze

      class << self
        attr_reader :map
      end
    end
  end
end
