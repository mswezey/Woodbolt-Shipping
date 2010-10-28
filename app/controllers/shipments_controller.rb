class ShipmentsController < ApplicationController
  before_filter :require_user
  protect_from_forgery :except => [:pending_post_data, :delivered_post_data, :invoiced_post_data, :bol_upload]

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
    @packing_slip = @shipment.build_packing_slip
    @packing_slip.list_items.build
  end
  
  def create
    @shipment = Shipment.new(params[:shipment])
    @shipment.submitter_id = current_user.id
    if @shipment.save
      @shipment.set_to_pending!
      flash[:notice] = "Successfully created shipment."
      redirect_to pending_shipments_path
    else
      render :action => 'new'
    end
  end
  
  def create_from_packing_slip
    @packing_slip = PackingSlip.find(params[:id])
    @shipment = Shipment.new(:submitter_id => current_user.id)
    @shipment.save(false)
    @packing_slip.update_attribute(:shipment_id, @shipment.id)
    redirect_to edit_shipment_path(@shipment)
  end
  
  def edit
    @shipment = Shipment.find(params[:id])
  end
  
  def update
    @shipment = Shipment.find(params[:id])
    if @shipment.update_attributes(params[:shipment])
      if @shipment.state == 'created'
        @shipment.set_to_pending!
      end
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
  
  def destroy
    @shipment = Shipment.find(params[:id])
    @shipment.destroy
    flash[:notice] = "Successfully destroyed shipment."
    redirect_to shipments_url
  end
  
  def bol_upload
    @shipment = Shipment.find(params[:id])
    if @shipment.update_attribute(:bol, params[:bol_file])
      render :js => 'saved'
    else
      render :js => 'error', :status => 500
    end
  end

  def pending
    @first_shipment = Shipment.find(1)
    shipments = Shipment.with_state(:pending).find(:all) do
      if params[:_search] == "true"
        reference_number    =~ "%#{params[:reference_number]}%" if params[:reference_number].present?
        bol_pro_number =~ "%#{params[:bol_pro_number]}%" if params[:bol_pro_number].present?
        carrier_id =~ "%#{params[:carrier_id]}%" if params[:carrier_id].present?
        deliver_by_date  =~ "%#{params[:deliver_by_date]}%" if params[:deliver_by_date].present?
        picked_up_at     =~ "%#{params[:picked_up_at]}%" if params[:picked_up_at].present?
        stock_transfer_wo_number      =~ "%#{params[:stock_transfer_wo_number]}%" if params[:stock_transfer_wo_number].present?
      end
      paginate :page => params[:page], :per_page => params[:rows]
      order_by "#{params[:sidx]} #{params[:sord]}"
    end
    respond_to do |format|
      format.html
      format.json { 
        render :json => shipments.to_jqgrid_json([:reference_number, :bol_pro_number, :carrier_name, :deliver_by_date, :bol_file, :packing_slip_info, :picked_up_at, :stock_transfer_wo_number, :delivered_check], 
                                                         params[:page], params[:rows], shipments.total_entries) }
    end
  end

  def pending_post_data
    if params[:oper] == "del"
      Shipment.find(params[:id]).destroy
    else
      shipment_params = { :bol_pro_number => params[:bol_pro_number], :carrier_id => params[:carrier_id], :deliver_by_date => params[:deliver_by_date], 
                      :picked_up_at => params[:picked_up_at], :stock_transfer_wo_number => params[:stock_transfer_wo_number] }
      if params[:id] == "_empty"
        Shipment.create(shipment_params)
      else
        Shipment.find(params[:id]).update_attributes(shipment_params)
      end
    end
    render :nothing => true
  end
  
  def delivered
    shipments = Shipment.with_state(:delivered).find(:all) do
      if params[:_search] == "true"
        reference_number    =~ "%#{params[:reference_number]}%" if params[:reference_number].present?
        bol_pro_number =~ "%#{params[:bol_pro_number]}%" if params[:bol_pro_number].present?
        carrier_id  =~ "%#{params[:carrier_id]}%" if params[:carrier_id].present?
        carrier_invoice_number     =~ "%#{params[:carrier_invoice_number]}%" if params[:carrier_invoice_number].present?
        cost      =~ "%#{params[:cost]}%" if params[:cost].present?
        classification_type      =~ "%#{params[:classification_type]}%" if params[:classification_type].present?
      end
      paginate :page => params[:page], :per_page => params[:rows]
      order_by "#{params[:sidx]} #{params[:sord]}"
    end
    respond_to do |format|
      format.html
      format.json { 
        render :json => shipments.to_jqgrid_json([:reference_number, :bol_pro_number, :carrier_name, :carrier_invoice_number, :cost, :classification_type, :has_credit, :invoiced_check],
                                                         params[:page], params[:rows], shipments.total_entries) }
    end
  end

  def delivered_post_data
    if params[:oper] == "del"
      Shipment.find(params[:id]).destroy
    else
      shipment_params = { :bol_pro_number => params[:bol_pro_number], :carrier_id => params[:carrier_id], 
                      :carrier_invoice_number => params[:carrier_invoice_number], :cost => params[:cost] }
      if params[:id] == "_empty"
        Shipment.create(shipment_params)
      else
        Shipment.find(params[:id]).update_attributes(shipment_params)
      end
    end
    render :nothing => true
  end
  
  def invoiced
    shipments = Shipment.with_state(:invoiced).find(:all) do
      if params[:_search] == "true"
        reference_number    =~ "%#{params[:reference_number]}%" if params[:reference_number].present?
        bol_pro_number =~ "%#{params[:bol_pro_number]}%" if params[:bol_pro_number].present?
        carrier_id  =~ "%#{params[:carrier_id]}%" if params[:carrier_id].present?
        carrier_invoice_number     =~ "%#{params[:carrier_invoice_number]}%" if params[:carrier_invoice_number].present?
        cost      =~ "%#{params[:cost]}%" if params[:cost].present?
        classification_type      =~ "%#{params[:classification_type]}%" if params[:classification_type].present?
        debit_memo_number      =~ "%#{params[:debit_memo_number]}%" if params[:debit_memo_number].present?
      end
      paginate :page => params[:page], :per_page => params[:rows]
      order_by "#{params[:sidx]} #{params[:sord]}"
    end
    respond_to do |format|
      format.html
      format.json { 
        render :json => shipments.to_jqgrid_json([:reference_number, :bol_pro_number, :carrier_name, :carrier_invoice_number, :cost, :classification_type, :credits_applied_check, :debit_memo_number],
                                                         params[:page], params[:rows], shipments.total_entries) }
    end
  end

  def invoiced_post_data
    if params[:oper] == "del"
      Shipment.find(params[:id]).destroy
    else
      shipment_params = { :bol_pro_number => params[:bol_pro_number], :carrier_id => params[:carrier_id], 
                      :carrier_invoice_number => params[:carrier_invoice_number], :cost => params[:cost], :debit_memo_number  => params[:debit_memo_number] }
      if params[:id] == "_empty"
        Shipment.create(shipment_params)
      else
        Shipment.find(params[:id]).update_attributes(shipment_params)
      end
    end
    render :nothing => true
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
  
  def credit
    @shipment = Shipment.find(params[:id])
    if @shipment.update_attribute(:has_credit, true)
      render :nothing => true
    else
      render :json => "#{@shipment.errors.map {|e| e.join(' ').to_s.humanize }.join(' ')}", :status => 400
    end
  end
  
  def credit_applied
    @shipment = Shipment.find(params[:id])
    if @shipment.update_attribute(:credits_applied, true)
      render :nothing => true
    else
      render :json => "#{@shipment.errors.map {|e| e.join(' ').to_s.humanize }.join(' ')}", :status => 400
    end
  end
  
end
