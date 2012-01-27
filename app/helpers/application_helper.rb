module ApplicationHelper

  def random_string
    char = ("a".."z").to_a + ("1".."9").to_a
    Array.new(6, '').collect{char[rand(char.size)]}.join
  end

  protected

  def header_image_path
    if current_controller == 'headers' && %w(edit show).include?(current_action)
      @header = Header.find(params[:id])
    else
      @header = Header.random
    end
    @header and @header.attachment.url or "/images/eldorado.jpg"
  end

  def header_css
    if @settings.clickable_header
      return ""
    else
      return "<style type=\"text/css\">.header { background: url('#{header_image_path}'); }</style>"
    end
  end

  def theme_css
    return "<style type=\"text/css\">@import url('/stylesheets/#{current_user.stylesheet}.css');</style>" if logged_in?
    return "<style type=\"text/css\">@import url('/stylesheets/application.css');</style>" if @settings.theme.blank?
    return "<style type=\"text/css\">@import url('#{@settings.theme}');</style>"
  end

  def page_title
    item = [@article, @category, @event, @forum, @header, @message, @topic, @user].compact.first if %w(show edit).include?(current_action)
    page = request.env['PATH_INFO'].delete('/').sub('new','').capitalize unless request.env['PATH_INFO'].nil?
    page = @settings.tagline if current_controller == 'home'
    "#{@settings.title}: #{item || page}"
  end

  def favicon_tag
    return "<link rel=\"shortcut icon\" href=\"#{@settings.favicon}\" />\n" unless @settings.favicon.blank?
    ""
  end

  def avatar_for(user, style = :medium)
    image_tag user.current_avatar.attachment.url(style) unless user.avatar.nil?
  end
  
  def steam_icon
    image_tag("/images/social/steam.png", :class => "steam_icon")
  end
  
  def steam_for(user)
    return "http://steamcommunity.com/profiles/#{user.steamid}"
  end

  def rank_for(user)
    return I18n.t(:rank_administrator) if user.admin
    return I18n.t(:rank_banned) if user.banned?
    @ranks ||=  Rank.find(:all, :order => "min_posts")
    return I18n.t(:rank_member) if @ranks.blank?
    for r in @ranks
      @rank = r if user.posts_count >= r.min_posts
    end
    return I18n.t(:rank_member) if @rank.nil? # if no ranks are low enough
    return h(@rank.title)
  end

  def tab(name)
    if name == current_controller
      'current_tab'
    elsif name == "forums" && %w(categories topics posts).include?(current_controller)
      'current_tab'
    elsif name == "users" && (current_controller == "avatars" || current_controller == "ranks")
      'current_tab'
    end
  end

  def enabled?(name)
    return true if Settings.disabled_tabs.nil?
    !Settings.disabled_tabs.include?(name)
  end

  def is_new?(item)
    return false unless logged_in?
    if item.is_a?(Topic)
      viewing = item.viewings.select {|v| v.user_id == current_user.id}.first
      (viewing.nil? || viewing.updated_at < item.updated_at) && current_user.all_viewed_at < item.updated_at
    else
      session[:online_at] < item.updated_at
    end
  end

  def icon_for(item)
    if item && is_new?(item)
      '<div class="icon inew"><!-- --></div>'.html_safe
    else
      '<div class="icon"><!-- --></div>'.html_safe
    end
  end

  def stream_icon_for(stream)
    if stream && stream.live?
      '<div class="icon inew"><!-- --></div>'.html_safe
    else
      '<div class="icon"><!-- --></div>'.html_safe
    end
  end

  def bb(text, *disable)
    text = BBCodeizer.bbcodeize(simple_format(h(text)), :disabled => disable)
    text.html_safe
  end

  def current_page(collection)
    I18n.t(:page)+' ' + number_with_delimiter(collection.current_page).to_s + ' ' + I18n.t(:of) + ' ' + number_with_delimiter(collection.total_pages).to_s unless collection.total_pages == 0
  end

  def prev_page(collection)
    num = collection.current_page > 1 && collection.current_page - 1
    link_to("&laquo; #{ I18n.t(:previous_page) }".html_safe, { :page => num }) if num
  end

  def next_page(collection)
    num = collection.current_page < collection.total_pages && collection.current_page + 1
    link_to("#{ I18n.t(:next_page) } &raquo;".html_safe, { :page => num }) if num
  end

  def t_no_of(item, count = 0)
    I18n.t item, :count => count, :print_count => number_with_delimiter(count)
  end

  def time_ago_or_time_stamp(from_time, to_time = Time.now.utc, include_seconds = true, detail = false)
    return '&ndash;' if from_time.nil?
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs) / 60).round
    distance_in_seconds = ((to_time - from_time).abs).round
    case distance_in_minutes
    when 0..1           then time = (distance_in_seconds < 60) ? I18n.t(:x_seconds_ago, :count => distance_in_seconds, :scope => 'datetime.distance_in_words' ) : I18n.t(:x_minutes_ago, :count => 1, :scope => 'datetime.distance_in_words' )
      when 2..59          then time = I18n.t(:x_minutes_ago, :count => distance_in_minutes, :scope => 'datetime.distance_in_words' )
      when 60..90         then time = I18n.t(:x_hours_ago, :count => 1, :scope => 'datetime.distance_in_words' )
      when 90..1440       then time = I18n.t(:x_hours_ago, :count => (distance_in_minutes.to_f / 60.0).round, :scope => 'datetime.distance_in_words' )
      when 1440..2160     then time = I18n.t(:x_days_ago, :count => 1, :scope => 'datetime.distance_in_words' )
      when 2160..2880     then time = I18n.t(:x_days_ago, :count => (distance_in_minutes.to_f / 1440.0).round, :scope => 'datetime.distance_in_words' )  # 1.5 days to 2 days
      else time = I18n.l(from_time, :format => :ed_date_only)  #from_time.strftime("%a, %d %b %Y")
    end
    return time_stamp(from_time) if (detail && distance_in_minutes > 2880)
    return time
  end

  def time_stamp(time, short = false)
    I18n.l(time, :format => ( short ? :ed_timestamp_short : :ed_timestamp ) )
  end

  def justintv_embed(stream)
    %Q{<object type="application/x-shockwave-flash" height="423" width="700" data="http://www.twitch.tv/widgets/live_embed_player.swf?channel=#{stream.identifier}" bgcolor="#000000" id="live_embed_player_flash" class="videoplayer">
      <param name="allowFullScreen" value="true" />
      <param name="allowScriptAccess" value="always" />
      <param name="allowNetworking" value="all" />
      <param name="movie" value="http://www.twitch.tv/widgets/live_embed_player.swf" />
      <param name="flashvars" value="hostname=www.twitch.tv&channel=#{stream.identifier}&auto_play=true&start_volume=50" />
    </object>}.html_safe
  end

  def own3dtv_embed(stream)
    %Q{<object width="938" height="528">
      <param name="movie" value="http://www.own3d.tv/livestream/#{ stream.identifier };autoplay=true" />
      <param name="allowscriptaccess" value="always" />
      <param name="allowfullscreen" value="true" />
      <param name="wmode" value="transparent" />
      <embed src="http://www.own3d.tv/livestream/#{ stream.identifier };autoplay=true" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="938" height="528" wmode="transparent"></embed>
    </object>}.html_safe
  end

  def justintv_chat_embed(stream)
    %Q{<iframe frameborder="0" scrolling="no" id="chat_embed" src="http://twitch.tv/chat/embed?channel=#{stream.identifier}&amp;popout_chat=true" height="423" width="234"></iframe>}.html_safe
  end
end
