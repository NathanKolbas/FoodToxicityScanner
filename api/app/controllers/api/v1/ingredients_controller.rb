module Api
  module V1
    class IngredientsController < ApplicationController
      # Use this to get the user from the token
      before_action :authenticate_request, only: %i[create update destroy]
      before_action :admin_required, only: :destroy
      before_action :find_ingredient, only: %i[show update log destroy]

      # GET /ingredients
      def index
        @ingredients = Ingredient.all
        render json: @ingredients, status: :ok
      end

      # GET /ingredients/:id
      def show
        render json: @ingredient, status: :ok
      end

      #  GET /ingredients/search/:params
      def search
        if valid_safety_rating(params[:safety_rating])
          # Use compact to remove any queries that are nil
          query = {
            id: params[:id],
            name: params[:name]&.upcase,
            description: params[:description],
            safety_rating: params[:safety_rating],
            created_by: params[:created_by]
          }.compact

          render json: Ingredient.where(query), status: :ok
        else
          render json: { error: "Invalid safety rating \"#{params[:safety_rating]}\"." }, status: :bad_request
        end
      end

      # POST /ingredients
      def create
        # Set who created it
        ingredient_json = user_params
        ingredient_json['created_by'] = @current_user.id

        @ingredient = Ingredient.new(ingredient_json)
        if @ingredient.save
          render json: @ingredient, status: :ok
        else
          render json: { error: @ingredient.errors }, status: :bad_request
        end
      end

      # PATCH/PUT /ingredients/:id
      def update
        # Log the update so users can see a history
        IngredientsLog.new(
          ingredient_id: @ingredient.id,
          user_id: @current_user.id,
          name: @current_user.name,
          description: @ingredient.description,
          safety_rating: @ingredient.safety_rating
        ).save

        if @ingredient&.update(user_params)
          render json: { message: 'Ingredient successfully updated.' }, status: :ok
        else
          render json: { error: @ingredient.errors }, status: :bad_request
        end
      end

      # GET /ingredients/:id/log
      def log
        logs = @ingredient.ingredients_logs
        if logs
          render json: logs, status: :ok
        else
          render json: { error: 'Unable to find any logs.' }, status: :bad_request
        end
      end

      # DELETE /ingredients/:id
      def destroy
        if @ingredient&.destroy
          render json: { message: 'Ingredient successfully deleted.' }, status: :ok
        else
          render json: { error: @ingredient.errors }, status: :bad_request
        end
      end

      private

      def user_params
        params.require(:ingredient).permit(:name, :description, :safety_rating).tap do |ingredient_params|
          unless @ingredient
            ingredient_params.require(:name)
            ingredient_params.require(:description)
          end
        end
      end

      def find_ingredient
        @ingredient = Ingredient.find(params[:id])
      end

      def valid_safety_rating(value)
        value.nil? || Ingredient.safety_ratings[value]
      end

      # How to override #as_json: Here is a little quirk. this will not override #as_json. To do that,
      # place it in the model. This is because #render handles it differently. Here we will have to
      # call it manually. Explanation:
      # https://stackoverflow.com/questions/2572284/how-to-override-to-json-in-rails
      #
      # This might be helpful later for how to handle rendering nested objects
      # https://stackoverflow.com/questions/17730121/include-associated-model-when-rendering-json-in-rails
      # https://api.rubyonrails.org/classes/ActiveModel/Serializers/JSON.html
      def render(*args)
        if params[:include_user]
          if args.first[:json].instance_of?(Ingredient)
            args.first[:json] = ingredient_with_user(args.first[:json])
          elsif args.first[:json].instance_of? Ingredient.const_get(:ActiveRecord_Relation)
            # This is very slow. Either I need to find a better way or just accept that it is slow.
            # ~5x slower. Seems to be from getting each user by id from the database.
            ingredients = []
            args.first[:json].each { |x| ingredients << ingredient_with_user(x) }
            args.first[:json] = ingredients
          end
        end

        super(*args)
      end

      def ingredient_with_user(ingredient)
        ingredient.as_json(
          include: {
            user: {
              except: :password_digest
            }
          }
        ).tap { |hash| hash['created_by'] = hash.delete 'user' }
      end
    end
  end
end
