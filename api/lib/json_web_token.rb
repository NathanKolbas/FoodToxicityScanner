module JsonWebToken
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, secret_key)
  end

  def self.decode(token)
    body = JWT.decode(token, secret_key)[0]
    HashWithIndifferentAccess.new body
  rescue JWT::ExpiredSignature
    Api::V1::Auth::EXPIRED_TOKEN
  rescue JWT::VerificationError
    Api::V1::Auth::INVALID_TOKEN
  end

  class << self
    private

    def secret_key
      Rails.application.credentials.dig(:secret_key_base)
    end
  end
end
