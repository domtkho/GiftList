class ContributionsController < ApplicationController
  before_action :set_contribution, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @contributions = Contribution.all
    respond_with(@contributions)
  end

  def show
    respond_with(@contribution)
  end

  def new
    @contribution = Contribution.new
    respond_with(@contribution)
  end

  def edit
  end

  def create
    @user_id = current_user.id
    @wanted_item_id = params[:wanted_item_id]
    @all_contributors = WantedItem.find(@wanted_item_id).contributions.pluck('user_id')
    if @all_contributors.include? @user_id
      @contribution_id = WantedItem.find(@wanted_item_id).contributions.find_by(user_id: @user_id).id
      @old_amount = Contribution.find(@contribution_id).amount
      @new_amount = @old_amount + params[:amount]
      WantedItem.find(@wanted_item_id).contributions.find_by(user_id: @user_id).update(amount: @new_amount)
      @contribution = WantedItem.find(@wanted_item_id).contributions.find_by(user_id: @user_id)
    else
      @contribution = Contribution.new({user_id: @user_id, wanted_item_id: params[:wanted_item_id], amount: params[:amount]})
    end

    respond_to do |format|
      if @contribution.save
        format.json { render :show, status: :created, location: @contribution }
      else
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @contribution.update(contribution_params)
    respond_with(@contribution)
  end

  def destroy
    @contribution.destroy
    respond_with(@contribution)
  end

  private
    def set_contribution
      @contribution = Contribution.find(params[:id])
    end

    def contribution_params
      params.require(:contribution).permit(:user_id, :wanted_item_id, :amount)
    end
end
