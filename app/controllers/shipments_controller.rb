class ShipmentsController < ApplicationController
  before_filter :require_user
  def index
    if params[:team_member_id]
      @user = User.find(params[:team_member_id])
      @shipments = params[:status] ? @user.assigned_shipments.with_state(params[:status].to_sym) : @user.assigned_shipments.all
    else
      if params[:status] 
        @shipments = Shipment.with_state(params[:status].to_sym) 
      else
        redirect_to shipments_path(:status => :pending)
      end
    end
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
      respond_to do |format|
         format.html {
           flash[:notice] = "Successfully updated shipment."
           redirect_to @shipment
         }
         format.js {
           render :nothing => true
         }
      end
    else
      render :action => 'edit'
    end
  end
  
  def deliver
    @shipment = Shipment.find(params[:id])
    if @shipment.deliver
      respond_to do |format|
         format.html {
           flash[:notice] = "Successfully updated shipment."
           redirect_to @shipment
         }
         format.js {
           render :nothing => true
         }
      end
    else
      respond_to do |format|
         format.html {
           render :action => 'edit'
         }
         format.js {
           render :json => "#{@shipment.errors.map {|e| e.join(' ').to_s.humanize }.join(' ')}", :status => 400
         }
      end
    end
  end
  
  def invoice
    @shipment = Shipment.find(params[:id])
    if @shipment.invoice
      respond_to do |format|
         format.html {
           flash[:notice] = "Successfully updated shipment."
           redirect_to @shipment
         }
         format.js {
           render :nothing => true
         }
      end
    else
      respond_to do |format|
         format.html {
           render :action => 'edit'
         }
         format.js {
           render :json => "#{@shipment.errors.map {|e| e.join(' ').to_s.humanize }.join(' ')}", :status => 400
         }
      end
    end
  end
  
  def destroy
    @shipment = Shipment.find(params[:id])
    @shipment.destroy
    flash[:notice] = "Successfully destroyed shipment."
    redirect_to shipments_url
  end
end
