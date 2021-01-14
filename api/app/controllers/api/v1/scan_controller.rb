module Api
  module V1
    class ScanController < ApplicationController
      # GET /scan
      def scan
        ingredients = []
        parse_ingredients(user_params).each do |i|
          # This should be replaced with search later instead of #find_by_name
          candidate = Ingredient.find_by_name(i.upcase) || Ingredient.new(name: i)
          ingredients.push(candidate)
        end

        render json: ingredients, status: :ok
      end

      private

      def user_params
        params.require(:scan_data)
      end

      # Returns back a list of ingredients from a string
      #
      # TODO: Implement what to do when ingredients are not separated by commas
      # Look into: It is probably better to do some NLP (Natural Language Processing) rather than regex
      def parse_ingredients(data)
        ingredients = []
        data.gsub!(/(?i)(ingredients)/, '') # Remove "Ingredients" ignore case
        if data.include? ','
          data.split(/[,.()]/).each do |s|
            candidate = s.gsub(/\W+/, ' ').strip
            ingredients.push(candidate) unless candidate.empty?
          end
        else
          # Not yet implemented
          nil
        end
        ingredients
      end
    end
  end
end
