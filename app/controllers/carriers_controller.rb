class CarriersController < ApplicationController
  def index
    @carriers = Carrier.all
  end
  
  def show
    @carrier = Carrier.find(params[:id])
  end
  
  def new
    @carrier = Carrier.new
  end
  
  def create
    @carrier = Carrier.new(params[:carrier])  
    if @carrier.save
      respond_to do |format|
        format.html {
          flash[:notice] = "Successfully created carrier."
          redirect_to @carrier
        }
        format.js {
          render :js => "$('#shipment_carrier_id').append($('<option></option>').attr('value','#{@carrier.id}').text('#{@carrier.name}'));$('#shipment_carrier_id').val(#{@carrier.id});$('#new-carrier').dialog('close');$('#new-carrier input').not('input:submit').val('');"
        }
      end
    else
      respond_to do |format|
        format.html {
          render :action => 'new'
        }
        format.js {
          render :js => "alert('#{@template.escape_javascript(@carrier.errors.map {|e| e.join(' ').to_s.humanize }.join(' '))}')"
        }
      end
    end
  end
  
  def edit
    @carrier = Carrier.find(params[:id])
  end
  
  def update
    @carrier = Carrier.find(params[:id])
    if @carrier.update_attributes(params[:carrier])
      flash[:notice] = "Successfully updated carrier."
      redirect_to @carrier
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @carrier = Carrier.find(params[:id])
    @carrier.destroy
    flash[:notice] = "Successfully destroyed carrier."
    redirect_to carriers_url
  end
end
