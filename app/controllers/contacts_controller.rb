class ContactsController < ApplicationController
  before_filter :require_user
  protect_from_forgery :except => [:post_data]
  
  def index
    contacts = Contact.find(:all) do
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
        render :json => contacts.to_jqgrid_json([:contact_type_name, :company_name, :contact_name, :email, :street_1, :street_2, :city, :state, :zip, :phone, :fax],
                                                         params[:page], params[:rows], contacts.total_entries) }
    end
  end

  def post_data
    if params[:oper] == "del"
      Contact.find(params[:id]).destroy
    else
      contact_params = { :contact_type_id => params[:contact_type_id], :company_name => params[:company_name], :contact_name => params[:contact_name], :email => params[:email], :street_1 => params[:street_1], :street_2 => params[:street_2], :city => params[:city], 
                      :state => params[:state], :zip => params[:zip], :phone => params[:phone], :fax => params[:fax] }
      if params[:id] == "_empty"
        Contact.create(contact_params)
      else
        Contact.find(params[:id]).update_attributes(contact_params)
      end
    end
    render :nothing => true
  end
  
  def show
    @contact = Contact.find(params[:id])
  end
  
  def new
    @contact = Contact.new
  end
  
  def create
    @contact = Contact.new(params[:contact])
    if @contact.save
      respond_to do |format|
        format.html {
          flash[:notice] = "Successfully created contact."
          redirect_to @contact
        }
        format.js {
          contact_type = @contact.contact_type
          if %w[shipper consignee].include?(contact_type)
            render :js => "$('#shipment_packing_slip_attributes_#{contact_type == "shipper" ? "shipper" : "consignee"}_id').append($('<option></option>').attr('value','#{@contact.id}').text('#{@contact.company_name}'));$('#shipment_packing_slip_attributes_#{contact_type == "shipper" ? "shipper" : "consignee"}_id').val(#{@contact.id});$('#new-contact').dialog('close');$('#new-contact input').not('input:submit').val('');"
          else
            render :js => "$('#shipment_bill_to_id').append($('<option></option>').attr('value','#{@contact.id}').text('#{@contact.company_name}'));$('#new-contact').dialog('close');$('#new-contact input').not('input:submit').val('');"
          end
        }
      end
    else
      respond_to do |format|
        format.html {
          render :action => 'new'
        }
        format.js {
          render :js => "alert('#{@template.escape_javascript(@contact.errors.map {|e| e.join(' ').to_s.humanize }.join(' '))}')"
        }
      end
    end
  end
  
  def edit
    @contact = Contact.find(params[:id])
  end
  
  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(params[:contact])
      flash[:notice] = "Successfully updated contact."
      redirect_to @contact
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    flash[:notice] = "Successfully destroyed contact."
    redirect_to contacts_url
  end
end
