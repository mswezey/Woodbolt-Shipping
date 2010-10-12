class CreditsController < ApplicationController
  protect_from_forgery :except => [:post_data]
  
  def index
    shipments = Shipment.find(:all, :conditions => {:has_credit => true}, :order => "deliver_by_date DESC") do
      if params[:_search] == "true"
        reference_number    =~ "%#{params[:reference_number]}%" if params[:reference_number].present?
        bol_pro_number =~ "%#{params[:bol_pro_number]}%" if params[:bol_pro_number].present?
        carrier_id  =~ "%#{params[:carrier_id]}%" if params[:carrier_id].present?
        carrier_invoice_number     =~ "%#{params[:carrier_invoice_number]}%" if params[:carrier_invoice_number].present?
        credit_amount      =~ "%#{params[:credit_amount]}%" if params[:credit_amount].present?
        credit_memo_number      =~ "%#{params[:credit_memo_number]}%" if params[:credit_memo_number].present?
        credit_memo      =~ "%#{params[:credit_memo]}%" if params[:credit_memo].present?
        debit_memo_number      =~ "%#{params[:debit_memo_number]}%" if params[:debit_memo_number].present?
      end
      paginate :page => params[:page], :per_page => params[:rows]
      order_by "#{params[:sidx]} #{params[:sord]}"
    end
    respond_to do |format|
      format.html
      format.json { 
        render :json => shipments.to_jqgrid_json([:reference_number, :bol_pro_number, :carrier_name, :carrier_invoice_number, :credit_amount, :credit_memo_number, :credit_memo, :debit_memo_number],
                                                         params[:page], params[:rows], shipments.total_entries) }
    end
  end

  def post_data
    if params[:oper] == "del"
      Shipment.find(params[:id]).destroy
    else
      shipment_params = { :credit_amount => params[:credit_amount], :credit_memo_number => params[:credit_memo_number], 
                      :credit_memo => params[:credit_memo], :debit_memo_number => params[:debit_memo_number] }
      if params[:id] == "_empty"
        Shipment.create(shipment_params)
      else
        Shipment.find(params[:id]).update_attributes(shipment_params)
      end
    end
    render :nothing => true
  end

  def show
  end

  def edit
  end

end
