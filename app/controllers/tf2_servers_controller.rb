class Tf2ServersController < ApplicationController
  
  before_filter :require_login, :except => [:index, :show]
  before_filter :can_edit, :only => [:edit, :update, :destroy]
  
  def index
    @tf2_servers = Tf2Server.paginate(:page => params[:page], :order => 'players desc, updated_at desc')
    @tf2_servers_count = Tf2Server.count
  end

  def show
    @tf2_server = Tf2Server.find(params[:id])
  end

  def new
    @tf2_server = Tf2Server.new
  end

  def create
	@tf2_server = current_user.tf2_servers.new(params[:tf2_server])
    if @tf2_server.save
      redirect_to @tf2_server
    else
      render :action => 'new'
    end
  end

  def edit
    @tf2_server = Tf2Server.find(params[:id])
  end
  
  def update
    @tf2_server = Tf2Server.find(params[:id])
    if @tf2_server.update_attributes(params[:tf2_server])
      redirect_to @tf2_server
    else
      render :action => 'edit'
    end
  end

  def destroy
    @tf2_server = Tf2Server.find(params[:id])
    @tf2_server.destroy
    redirect_to tf2_servers_path
  end 

  def confirm_delete
    @tf2_server = Tf2Server.find(params[:id])
  end
end
