class ItemsController < ApplicationController
  def index
    @items = Item.all
  end
  
  def show
    @item = Item.find(params[:id])
    respond_to do |format|
      format.html {}
      format.js {
        render :json => @item.to_json
      }
    end
  end
  
  def new
    @item = Item.new
  end
  
  def create
    @item = Item.new(params[:item])
    if @item.save
      respond_to do |format|
        format.html {
          flash[:notice] = "Successfully created item."
          redirect_to @item
        }
        format.js {
          render :js => "$('.item-select').append($('<option></option>').attr('value','#{@item.id}').text('#{@item.name} (#{@item.uom})'));$('#new-item').dialog('close');alert('#{@template.escape_javascript(@item.name)} sucessfully added! Select from drop down list to choose.')"
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
    @item = Item.find(params[:id])
  end
  
  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      respond_to do |format|
        format.html {
          flash[:notice] = "Successfully updated item."
          redirect_to @item
        }
        format.js {
          render :js => "$('.item-select option[value=#{@item.id}]').text('#{@item.name} (#{@item.uom})');$('#new-item').dialog('close');$('.item-select').trigger('change');"
        }
      end
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed item."
    redirect_to items_url
  end
end
