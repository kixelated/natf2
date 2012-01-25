class StreamsController < ApplicationController
  
  before_filter :require_login, :except => [:index, :show]
  before_filter :can_edit, :only => [:edit, :update, :destroy]
  
  def index
    @streams = Stream.paginate(:page => params[:page], :order => 'live desc, viewers desc')
    @streams_count = Stream.count
  end

  def show
    @stream = Stream.find(params[:id])
  end

  def new
    @stream = Stream.new
  end

  def create
    @stream = current_user.streams.new(params[:stream])
    if @stream.save
      redirect_to @stream
    else
      render :action => 'new'
    end
  end

  def edit
    @stream = Stream.find(params[:id])
  end
  
  def update
    @stream = Stream.find(params[:id])
    if @stream.update_attributes(params[:stream])
      redirect_to @stream
    else
      render :action => 'edit'
    end
  end

  def destroy
    @stream = Stream.find(params[:id])
    @stream.destroy
    redirect_to streams_path
  end 

  def confirm_delete
    @stream = Stream.find(params[:id])
  end
end
