# Renjie Long
# Bryant Chang

class ChannelController < ApplicationController
  respond_to :html, :js

  def mychannels
    @results = Favorite.get_favorite(current_user.id)
    # p "*"*80
    # p @results
  end

  # Get all shows from MovieDB
  def browse
    themoviedb = ApplicationHelper::themoviedb
    paramaters = {'api_key'=> themoviedb[:api_key], 'page'=> 1}
    data = ApplicationHelper.get(themoviedb[:endpoint]+themoviedb[:on_the_air], paramaters)
    set_current_endpoint(themoviedb[:endpoint]+themoviedb[:on_the_air])
    @on_the_air = JSON.parse data
    @results = @on_the_air['results']
    set_current_query(nil)
    set_total_page(@on_the_air["total_pages"])
    set_current_page(1)

  end

  def search
    themoviedb = ApplicationHelper::themoviedb
    if !params[:query].nil?
      query = params[:query].strip
      if query.empty?
        set_current_query(nil)
        set_current_endpoint(themoviedb[:endpoint]+themoviedb[:on_the_air])
        set_current_page(1)
      else
        set_current_query(query)
        set_current_endpoint(themoviedb[:endpoint]+themoviedb[:search])
        set_current_page(1)
      end
    end
    redirect_to action: 'browse_list'

  end

  def next_page
    current_page = get_current_page

    if(current_page < get_total_page)
      set_current_page(current_page + 1)
      redirect_to action: 'browse_list'
    end

    
  end


  def previous_page
    current_page = get_current_page

    if(current_page > 1)
      set_current_page(current_page - 1)
      redirect_to action: 'browse_list'
    end
    
  end

  def browse_list
    themoviedb = ApplicationHelper::themoviedb
    if !get_current_query.nil?
      paramaters = {'api_key'=> themoviedb[:api_key], 'query' => get_current_query, 'page'=> get_current_page}
    else
      paramaters = {'api_key'=> themoviedb[:api_key], 'page'=> get_current_page}
    end

    data = ApplicationHelper.get(get_current_endpoint, paramaters)
    @on_the_air = JSON.parse data
    @results = @on_the_air['results']
    set_total_page(@on_the_air["total_pages"])
  end

  # Get details of a show from MovieDB
  def details
    themoviedb = ApplicationHelper::themoviedb
    parameters = {'api_key'=> themoviedb[:api_key]}
    data = ApplicationHelper.get(themoviedb[:endpoint]+themoviedb[:tv]+params["id"],parameters)
    show = JSON.parse data
    new_json = Channel.parse_detail(show)
    render :json => new_json
  end

  def post
    if params.has_key?(:uid)
      cuser = User.find(params[:uid])
      @message = cuser.messages.create!(message_params)
    elsif user_signed_in?
      @message = current_user.messages.create!(message_params)
    else
      @message = Message.create!(message_params)
    end

    tags = message_params[:body].scan(/#\S+/)
    if !tags.empty?
      cid = message_params[:channel_id]
      # p cid
      # p tags[0][1..-1]
      topic = Topic.find_or_create_by(name: tags[0][1..-1], channel_id: cid)
      @message.update(topic_id: topic.id)
    else
      main_id = Topic.find_or_create_by(channel_id: cid, name: "Main").id
      @message.update(topic_id: main_id)
    end
    Channel.find(params[:channel_id]).last_message = DateTime.now
    render :json => {success: 1}
  end

  def room
    if params.has_key?(:id)
      id = params[:id].to_i
      @channel = Channel.find(id)
      @messages = Channel.get_messages(params[:id])
      @user = current_user
      @topic_names = Channel.get_topics(params[:id])
      render :index
    end
  end

  def add_active
    if current_user != nil
      Channel.active_add(params, current_user)
    end
    render nothing: true
  end

  def delete_active
    Channel.active_delete(params, current_user)
    render nothing: true
  end

  def user_list
    userlist = Channel.active_user_list(params, current_user)
    render json: {user_list: userlist}
  end

  def update_active
    Channel.active_update(params, current_user)
    render nothing: true
  end


  def follow
    # p "*" *80
    # p params
    Channel.follow(params, current_user, channel_params)
    render nothing: true
  end

  def unfollow
    Channel.unfollow(params, current_user)
    render nothing: true
  end

  def check_following
    # p params[:id]
    following = Channel.following(params, current_user)
    render json: {following: following}
  end

  def create
    @channel = Channel.create(channel_params)
    # @channel.topics.create(:name => :Main)
  end

  def messages
    # m = Message.where(:channel_id => params[:id])
    # render json: {messages: m}
    if params.has_key?(:topic)
      render json: {messages: Channel.get_messages_for_topic(params[:id], params[:topic])}
    else
      render json: {messages: Channel.get_messages(params[:id])}
    end
  end

  # def new_messages
  #   if params.has_key?(:time)
  #     if Channel.find(params[:id]).new_messages?(params[:time])
  #       if params.has_key?(:topic)
  #         render json: {messages: Channel.get_messages_for_topic(params[:id], params[:topic]), time: DateTime.now, new: true}
  #       else
  #         render json: {messages: Channel.get_messages(params[:id]), time: DateTime.now, new: true}
  #       end
  #     else
  #       render json: {time: DateTime.now, new: false}
  #     end
  #   else
  #     if params.has_key?(:topic)
  #       render json: {messages: Channel.get_messages_for_topic(params[:id], params[:topic]), time: DateTime.now, new: true}
  #     else
  #       render json: {messages: Channel.get_messages(params[:id]), time: DateTime.now, new: true}
  #     end
  #   end
  # end


  def new_messages
    if params.has_key?(:time) and !Channel.find(params[:id]).new_messages?(params[:time])
      render json: {time: DateTime.now, new: false}
    else
      if params.has_key?(:topic)
        render json: {messages: Channel.get_messages_for_topic(params[:id], params[:topic]), time: DateTime.now, new: true}
      else
        render json: {messages: Channel.get_messages(params[:id]), time: DateTime.now, new: true}
      end
    end
  end

  def find
    if params.has_key?(:api_id)
      @channel = Channel.find_or_create_by!(api_id: params[:api_id]) do |c|
        c.name = params[:name]
        c.image_url = params[:image_url]
        c.network = params[:network]
      end
      url = "'/channel/"+@channel.id.to_s+"'"
      render :js => "window.location ="+url
    end
    #render :nothing => true
  end

  def add_topic
    if current_user != nil
      id = params[:id].to_i
      @channel = Channel.find(id)
      @channel.create_topic(params)
    end
    render nothing: true
  end

  def topics
    if params.has_key?(:id)
      @topics = Channel.get_topics(params[:id])
      # p @topics
      render json: {topics: @topics}
    end
  end

  def get_user_count
    render json: {count: Channel.get_user_count(params[:id], params[:topic_name])}
  end

  def messages_for_topic
    # p"*!" *80
    render json: {messages: Channel.get_messages_for_topic(params[:id], params[:topic])}
  end

  def topics_for_user
    if params.has_key?(:id) and params.has_key?(:topic)
      topics = Channel.get_topics_for_user(params[:id], params[:topic], current_user)
      render json: {topics: topics}
    end
  end

private
  $total_page
  $current_page
  $current_endpoint
  $current_query

  def set_current_query(current_query)
    $current_query = current_query
    return $current_query
  end
  def get_current_query
    return $current_query
  end

  def set_current_page(current_page)
    $current_page = current_page
    return $current_page
  end
  def get_current_page
    return $current_page
  end

  def set_current_endpoint(current_endpoint)
    $current_endpoint = current_endpoint
    return $current_endpoint
  end

  def get_current_endpoint
    return $current_endpoint
  end

  def set_total_page(total_page)
    $total_page = total_page
    return $total_page
  end
  def get_total_page
    return $total_page
  end
  def message_params
    params.permit(:body, :channel_id)
  end

  def channel_params
    params.permit(:api_id, :name, :image_url, :network)
  end
  
end
