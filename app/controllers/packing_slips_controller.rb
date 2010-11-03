class PackingSlipsController < ApplicationController
  
  def index
    packing_slips = PackingSlip.find(:all, :conditions => {:shipment_id => nil}) do
      if params[:_search] == "true"
        shipper    =~ "%#{params[:shipper]}%" if params[:shipper].present?
        reference_number =~ "%#{params[:reference_number]}%" if params[:reference_number].present?
        consignee =~ "%#{params[:consignee]}%" if params[:consignee].present?
        pallets  =~ "%#{params[:pallets]}%" if params[:pallets].present?
        total_weight     =~ "%#{params[:total_weight]}%" if params[:total_weight].present?
      end
      paginate :page => params[:page], :per_page => params[:rows]
      order_by "#{params[:sidx]} #{params[:sord]}"
    end
    respond_to do |format|
      format.html 
      format.json { 
        render :json => packing_slips.to_jqgrid_json([:shipper_name, :consignee_name, :reference_number, :pallets, :total_weight, :jqgrid_action_links],
                                                         params[:page], params[:rows], packing_slips.total_entries) }
    end
  end

  def post_data
    if params[:oper] == "del"
      PackingSlip.find(params[:id]).destroy
    else
      packing_slip_params = { :shipper_id => params[:shipper_id], :consignee_id => params[:consignee_id], :reference_number => params[:reference_number],
                      :pallets => params[:pallets], :total_weight => params[:total_weight] }
      if params[:id] == "_empty"
        PackingSlip.create(packing_slip_params)
      else
        PackingSlip.find(params[:id]).update_attributes(packing_slip_params)
      end
    end
    render :nothing => true
  end
  
  def list_items
    if params[:id].present?
       list_items = PackingSlip.find(params[:id]).list_items.find(:all) do
         paginate :page => params[:page], :per_page => params[:rows]      
         order_by "#{params[:sidx]} #{params[:sord]}"        
       end
       total_entries = list_items.total_entries
     else
       list_items = []
       total_entries = 0
     end
     if request.xhr?
       render :json => list_items.to_jqgrid_json([:item_name, :qty, :lot_number, :comments], params[:page], params[:rows], total_entries) and return
     end
  end
  
  def show
    @packing_slip = PackingSlip.find(params[:id])
  end
  
  def new
    @packing_slip = PackingSlip.new
    @packing_slip.list_items.build
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
