class ApplicationController < ActionController::API
  attr_reader :current_user

  private

  def authenticate_request
    command = Api::V1::Auth::AuthorizeApiRequest.call(request.headers)

    if command.success?
      @current_user = command.result
    else
      error_code = command.errors[:error_code].first
      render json: { error_code: error_code, message: Api::V1::Auth.to_s(error_code) }, status: :unauthorized
    end
  end

  def token_present?
    request.headers['Authorization'].present?
  end

  def admin_required
    return if @current_user&.admin

    unauthorized_response
  end

  def unauthorized_response
    error_code = Api::V1::Auth::NOT_AUTHORIZED
    render json: { error_code: error_code, message: Api::V1::Auth.to_s(error_code) }, status: :unauthorized
  end
end
