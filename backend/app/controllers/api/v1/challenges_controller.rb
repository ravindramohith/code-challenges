module Api
  module V1
    class ChallengesController < ApplicationController
      def index
        # show all challenges
        @challenges = Challenge.all
        render json: @challenges
      end

      def show
        begin
          challenge = Challenge.find(params[:id])
          render json: challenge
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Challenge not found' }, status: :not_found
        end
      end

      def create
        challenge = Challenge.new(challenge_body)
        if challenge.save
          render json: { message: "Challenge created successfully", data: challenge}
        else
          render json: { message: "Challenge not created", data: challenge.errors }
        end
      end

      def update
        challenge = Challenge.find(params[:id])
        if challenge.update(challenge_body)
          render json: { message: "Challenge updated successfully", data: challenge}
        else
          render json: { message: "Challenge not updated", data: challenge.errors }
        end
      end

      def destroy
        challenge = Challenge.find(params[:id])
        if not challenge
          render json: { error: 'Challenge not found' }, status: :not_found
          return
        end
        if challenge.destroy
          render json: { message: "Challenge deleted successfully", data: challenge}, status: :ok
        else
          render json: { message: "Challenge not deleted", data: challenge.errors }, status: :unprocessable_entity
        end
      end

      private
      def challenge_body
        return JSON.parse(request.body.read)
      end
    end
  end
end