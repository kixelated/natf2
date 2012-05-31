class TfserversController < ApplicationController
  
  before_filter :require_login, :except => [:index, :show]
  before_filter :can_edit, :only => [:edit, :update, :destroy]
  
  def index
    @tfservers = Tfserver.paginate(:page => params[:page], :order => 'players desc, updated_at desc')
    @tfservers_count = Tfserver.count
  end

  def show
    @tfserver = Tfserver.find(params[:id])
  end

  def new
    @tfserver = Tfserver.new
  end

  def create
    puts "create server"
	@tfserver = current_user.tfservers.new(params[:tfserver])
    if @tfserver.save
      redirect_to @tfserver
    else
      render :action => 'new'
    end
  end

  def edit
    @tfserver = Tfserver.find(params[:id])
  end
  
  def update
    @tfserver = Tfserver.find(params[:id])
    if @tfserver.update_attributes(params[:tfserver])
      redirect_to @tfserver
    else
      render :action => 'edit'
    end
  end

  def destroy
    @tfserver = Tfserver.find(params[:id])
    @tfserver.destroy
    redirect_to tfservers_path
  end 

  def confirm_delete
    @tfserver = Tfserver.find(params[:id])
  end
end
