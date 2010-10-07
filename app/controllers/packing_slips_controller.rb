class PackingSlipsController < ApplicationController
  def index
    @packing_slips = PackingSlip.all
  end
  
  def show
    @packing_slip = PackingSlip.find(params[:id])
  end
  
  def new
    @packing_slip = PackingSlip.new
  end
  
  def create
    @packing_slip = PackingSlip.new(params[:packing_slip])
    if @packing_slip.save
      flash[:notice] = "Successfully created packing slip."
      redirect_to @packing_slip
    else
      render :action => 'new'
    end
  end
  
  def edit
    @packing_slip = PackingSlip.find(params[:id])
  end
  
  def update
    @packing_slip = PackingSlip.find(params[:id])
    if @packing_slip.update_attributes(params[:packing_slip])
      flash[:notice] = "Successfully updated packing slip."
      redirect_to @packing_slip
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @packing_slip = PackingSlip.find(params[:id])
    @packing_slip.destroy
    flash[:notice] = "Successfully destroyed packing slip."
    redirect_to packing_slips_url
  end
end
