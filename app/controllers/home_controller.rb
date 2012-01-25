class HomeController < ApplicationController

  def index
    @date = Time.new(params[:date] || Time.now.utc.asctime)
    @articles = Article.get
    @avatars = Avatar.find(:all, :limit => 3, :include => :user, :order => 'avatars.updated_at desc')
    @message = Message.last
    @chatters = User.chatting
    @events = Event.find(:all, :conditions => ['date between ? and ?', @date.strftime("%Y-%m") + '-01', @date.next_month.strftime("%Y-%m") + '-01'])
    @headers = Header.find(:all, :limit => 3, :include => :user, :order => 'headers.created_at desc')
    @topics = Topic.paginate(:page => params[:page], :include => [:user, :forum, :last_poster], :order => 'last_post_at desc')
    @uploads = Upload.find(:all, :limit => 3, :include => :user, :order => 'uploads.updated_at desc')
    @users = User.find(:all, :limit => 3, :order => 'profile_updated_at desc')
    @streams = Stream.find(:all, :order => 'viewers desc', :conditions => {:live => true})
  end

  def help
  end
end
