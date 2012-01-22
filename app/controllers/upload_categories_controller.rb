class UploadCategoriesController < ApplicationController
  before_filter :require_admin, :except => [:index, :show]

  def index
    redirect_to uploads_path
  end

  def new
    @category = UploadCategory.new
  end

  def create
    @category = UploadCategory.new(params[:upload_category])

    if @category.save
      redirect_to uploads_path
    else
      render :action => 'new'
    end
  end
end
