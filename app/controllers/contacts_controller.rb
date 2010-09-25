class ContactsController < ApplicationController
  def index
    @contacts = Contact.all
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
          render :js => "$('#shipment_#{@contact.contact_type == "Shipper" ? "shipper" : "cosignee"}_id').append($('<option></option>').attr('value','#{@contact.id}').text('#{@contact.name}'));$('#shipment_#{@contact.contact_type == "Shipper" ? "shipper" : "cosignee"}_id').val(#{@contact.id});$('#new-contact').dialog('close');$('#new-contact input').not('input:submit').val('');"
        }
      end
    else
      respond_to do |format|
        format.html {
          render :action => 'new'
        }
        format.js {
          render :js => "alert('#{@contact.errors.map {|e| e.join(' ').to_s.humanize }.join(' ')}')"
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
