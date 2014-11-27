class WantedItemsController < ApplicationController
  before_action :set_wanted_item, only: [:edit, :update, :destroy]

  # POST /api/wanted_items/submit.json
  def submit

    item = Item.find(params[:item_id])
    list = current_user.lists.first
    if !(list.items.include? item)
      @wanted_item = WantedItem.create({user_id: current_user.id, item_id: params[:item_id], list_id: current_user.lists.first.id})
      list.wanted_items << @wanted_item
      respond_to do |format|
        format.json { render :show, status: :created, location: @wanted_item }
      end
    else
      respond_to do |format|
        format.json { head :ok }
      end
    end
  end

  def contributionData
    @wanted_item = WantedItem.find(params[:id])
    @contributions = @wanted_item.contributions
  end


  def destroy
    @wanted_item.destroy
    respond_to do |format|
      format.json { redirect_to wanted_items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /wanted_items
  # GET /wanted_items.json
  def index
    @wanted_items = WantedItem.all
  end

  # GET /wanted_items/1
  # GET /wanted_items/1.json
  def show
    @wanted_item = WantedItem.find(params[:id])
  end

  # GET /wanted_items/new
  def new
    @wanted_item = WantedItem.new
  end

  # GET /wanted_items/1/edit
  def edit
  end

  # POST /wanted_items
  # POST /wanted_items.json
  def create
    @wanted_item = WantedItem.new(wanted_item_params)

    respond_to do |format|
      if @wanted_item.save
        format.html { redirect_to @wanted_item, notice: 'Wanted item was successfully created.' }
        format.json { render :show, status: :created, location: @wanted_item }
      else
        format.html { render :new }
        format.json { render json: @wanted_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wanted_items/1
  # PATCH/PUT /wanted_items/1.json
  def update
    respond_to do |format|
      if @wanted_item.update(wanted_item_params)
        format.html { redirect_to @wanted_item, notice: 'Wanted item was successfully updated.' }
        format.json { render :show, status: :ok, location: @wanted_item }
      else
        format.html { render :edit }
        format.json { render json: @wanted_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wanted_items/1
  # DELETE /wanted_items/1.json
  def destroy
    @wanted_item.destroy
    respond_to do |format|
      format.html { redirect_to wanted_items_url, notice: 'Wanted item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wanted_item
      @wanted_item = WantedItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wanted_item_params
      params.require(:wanted_item).permit(:user_id)
    end
end
