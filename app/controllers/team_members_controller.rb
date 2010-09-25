class TeamMembersController < ApplicationController

  def index
    @users = User.all
    @last_updated = User.first(:order => 'updated_at DESC')
  end

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created team member."
      redirect_to team_member_path(@user)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated team member."
      redirect_to team_member_path(@user)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Successfully destroyed team member."
    redirect_to team_members_url
  end
end
