module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_request, except: %i[create show]
      before_action :find_user, only: %i[show update destroy]
      before_action :admin_required, only: :search

      # GET /users
      def index
        # This will give back the current user with their auth token
        render json: @current_user, status: :ok
      end

      # GET /users/:id
      def show
        # Check if admin or if they are getting their user
        # return unauthorized_response unless @current_user.id == params[:id].to_i || @current_user.admin

        render json: @user, status: :ok
      end

      #  GET /users/search/:params
      def search
        # Use compact to remove any queries that are nil
        query = {
          id: params[:id],
          name: params[:name],
          email: params[:email]
        }.compact

        render json: User.where(query)
      end

      # POST /users
      def create
        @user = User.new(user_params)
        if @user.save
          render json: @user, status: :ok
        else
          render json: { error: @user.errors }, status: :bad_request
        end
      end

      # PATCH/PUT /users/:id
      def update
        # Check if admin or if they are modifying their user
        return unauthorized_response unless @current_user.id == params[:id].to_i || @current_user.admin

        if @user&.update(user_params)
          render json: { message: 'User successfully updated.' }, status: :ok
        else
          render json: { error: @user.errors }, status: :bad_request
        end
      end

      # DELETE /users/:id
      def destroy
        # Check if admin or if they are deleting their user
        return unauthorized_response unless @current_user.id == params[:id].to_i || @current_user.admin

        if @user&.destroy
          render json: { message: 'User successfully deleted.' }, status: :ok
        else
          render json: { error: @user.errors }, status: :bad_request
        end
      end

      private

      def user_params
        # Only allow admin if the user is an admin, else filter it out
        filters = @current_user&.admin ? %i[name email password admin] : %i[name email password]

        params.require(:user).permit(filters).tap do |user_params|
          unless @user
            user_params.require(:name)
            user_params.require(:email)
            user_params.require(:password)
          end
        end
      end

      def find_user
        @user = User.find(params[:id])
      end
    end
  end
end
