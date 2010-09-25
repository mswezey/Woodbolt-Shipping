class ShipmentsController < ApplicationController
  before_filter :require_user
  def index
    @shipments = params[:status] ? Shipment.with_state(params[:status].to_sym) : Shipment.all
  end
  
  def show
    @shipment = Shipment.find(params[:id])
  end
  
  def new
    @shipment = Shipment.new
  end
  
  def create
    @shipment = Shipment.new(params[:shipment])
    @shipment.submitter_id = current_user.id
    if @shipment.save
      flash[:notice] = "Successfully created shipment."
      redirect_to @shipment
    else
      render :action => 'new'
    end
  end
  
  def edit
    @shipment = Shipment.find(params[:id])
  end
  
  def update
    @shipment = Shipment.find(params[:id])
    if @shipment.update_attributes(params[:shipment])
      flash[:notice] = "Successfully updated shipment."
      redirect_to @shipment
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @shipment = Shipment.find(params[:id])
    @shipment.destroy
    flash[:notice] = "Successfully destroyed shipment."
    redirect_to shipments_url
  end
end
