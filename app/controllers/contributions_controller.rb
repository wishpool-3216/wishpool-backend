class ContributionsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_gift, only: [:index, :create]
  before_action :set_contribution, only: [:show, :update, :destroy]
  before_action :check_permissions, only: [:update, :destroy]

  def index
    render json: @gift.contributions
  end

  def show
    render json: @contribution
  end

  def create
    Contribution.transaction do
      @contribution = @gift.contributions.create!(contribution_params)
    end
    render json: @contribution
  end

  def update
    Contribution.transaction do
      @contribution.update!(contribution_params)
    end
    render json: @contribution
  end

  def destroy
    Contribution.transaction do
      @contribution.destroy!
    end
    render json: {}
  end

  private

  def contribution_params
    permit = [:amount]
    params.permit(permit)
  end

  def set_gift
    @gift = Gift.find(params[:gift_id])
  end

  def set_contribution
    @contribution = Contribution.find(params[:id])
  end

  def check_permissions
    return if current_user == @contribution.creator
    render json: {}, status: :forbidden
  end
end
