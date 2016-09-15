##
# Handles gift routes

class GiftsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_gift, only: [:show, :update, :destroy]
  before_action :check_permissions, only: [:update, :destroy]

  def index
    @user = User.find(params[:user_id])
    render json: @user.gifts
  end

  def create
    @user = User.find(params[:user_id])
    Gift.transaction do
      @gift = @user.gifts.create!(gift_params)
    end
    render json: @gift
  end

  def show
    render json: @gift
  end

  def update
    Gift.transaction do
      @gift.update!(gift_params)
    end
    render json: @gift
  end

  def destroy
    Gift.transaction do
      @gift.destroy!
    end
    render json: @gift
  end

  private

  def gift_params
    permit = [:name, :expected_price, :publicity, :expiry,
              :description, :image_file_name, :image_content_type,
              :image_file_size, :image_updated_at]
    params.permit(permit)
  end

  def set_gift
    @gift = Gift.find(params[:id])
  end

  def check_permissions
    return if current_user == @gift.recipient || current_user == @gift.creator
    render json: {}, status: :forbidden
  end
end
