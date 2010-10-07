class ListItemsController < ApplicationController
  def index
    @list_items = ListItem.all
  end
  
  def show
    @list_item = ListItem.find(params[:id])
  end
  
  def new
    @list_item = ListItem.new
  end
  
  def create
    @list_item = ListItem.new(params[:list_item])
    if @list_item.save
      flash[:notice] = "Successfully created list item."
      redirect_to @list_item
    else
      render :action => 'new'
    end
  end
  
  def edit
    @list_item = ListItem.find(params[:id])
  end
  
  def update
    @list_item = ListItem.find(params[:id])
    if @list_item.update_attributes(params[:list_item])
      flash[:notice] = "Successfully updated list item."
      redirect_to @list_item
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @list_item = ListItem.find(params[:id])
    @list_item.destroy
    flash[:notice] = "Successfully destroyed list item."
    redirect_to list_items_url
  end
end
