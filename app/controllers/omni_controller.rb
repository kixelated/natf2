class OmniController < ApplicationController

  skip_before_filter :verify_authenticity_token
    
  def steam_login
    @user = User.find_by_id(session[:user_id])
    if @user
      if @user.steamid.blank?
        @user.steamid = auth_hash.uid
        flash[:notice] = "That steamid has already been taken." unless @user.save
      else
        flash[:notice] = "You cannot change your steamid."
      end
    end
    redirect_to edit_user_path(@user)
  end
  
  def steam_login_failure
    redirect_to current_user
    flash[:notice] = "Could not log you in. #{params[:message]}"
  end
  
  protected
  
  def auth_hash
    request.env['omniauth.auth']
  end
end