class ImagesController < ProxyController
  # include RevealBannedUser
  skip_before_action :verify_authenticity_token
  skip_before_action :check_current_user, only: [:share]
  skip_before_action :check_banned_user, only: [:share]
  layout false, only: [:share]
  #layout 'application', :except => :share
  #layout :false, only: [:share]
  def show
    @image = Image.find(params[:id])
  end

  def create
    if params.key?(:image)
      @images = current_user.images.build(image: params[:image][:image])
      @images.title_img = params[:image][:title_img]
      @images.tags = params[:image][:tags]
      if @images.save
        flash[:success] = 'Image uploaded!Wait moderation :)'
        # IMAGE_VOTES_COUNT.rank_member(@images.id.to_s, 0)
        redirect_to current_user
      else
        flash[:warning] = 'Image do not uploaded!'
        redirect_to root_url
      end
    else
      flash[:warning] = 'Choose image!'
      redirect_to current_user
    end
  end

  def share
    @shareimg = Image.find(params[:id])
    render :layout => false
  end
  
  def create_remote
    if params.key?(:url_image)
      @images = current_user.images.build(remote_image_url: params["url_image"]["url"])
      @images.tags = params["insta_tags"].join(' ') if params["insta_tags"]
      @images.title_img = params[:text].split('#')[0] if params[:text]
      if @images.save
        flash[:success] = 'Image uploaded from Instagram!Wait moderation :)'
        # IMAGE_VOTES_COUNT.rank_member(@images.id.to_s, 0)
        redirect_to current_user
      else
        flash[:warning] = 'Image do not uploaded!'
        redirect_to current_user
      end
    end
  end

  def destroy
    @image.destroy
    flash[:success] = 'Image deleted'
    redirect_to request.referer || root_url
    # redirect_back(fallback_location: root_url)
  end

  # def upvote
  #   @image = Image.find(params[:id])
  #   if !current_user.voted_up_on?(@image)
  #     # @image.upvote_by current_user
  #     # $redis.set(params[:id].to_s,@image.score)
  #     begin
  #       Redis.new.set('getstatus', 1)
  #       @image.upvote_by current_user
  #       IMAGE_VOTES_COUNT.rank_member(@image.id.to_s, @image.score)
  #     rescue Redis::CannotConnectError
  #       @image.upvote_by current_user
  #     end
  #   else
  #     flash[:warning] = 'You already voted for this image!'
  #   end
  #   # inputs = {:id_image => params[:id], :id_user => current_user.id}
  #   # @upvote = UpvoteImage.run(inputs)
  #   # flash[:warning] = @upvote
  #   redirect_to root_url
  # end

  def upvote_like
    @image = Image.find(params[:id])
    unless @image.likes.where(user_id: current_user.id).count > 0
      # @image.upvote_by current_user
      # $redis.set(params[:id].to_s,@image.score)
      begin
        Redis.new.set('getstatus', 1)
        #@image.upvote_by current_user
        @image.update_attributes(likes_img: @image[:likes_img] + 1)
        @image.likes.create(user_id: current_user.id)        
        IMAGE_VOTES_COUNT.rank_member(@image.id.to_s, @image.score_like)
      rescue Redis::CannotConnectError
        @image.likes.create(user_id: current_user.id)
        @image.likes_img += 1
      end
    else
      flash[:warning] = 'You already voted for this image!'
    end
    # inputs = {:id_image => params[:id], :id_user => current_user.id}
    # @upvote = UpvoteImage.run(inputs)
    # flash[:warning] = @upvote
    redirect_to root_url
  end

  # def downvote
  #   @image = Image.find(params[:id])
  #   if !current_user.voted_down_on?(@image)
  #     begin
  #       Redis.new.set('getstatus', 1)
  #       @image.downvote_by current_user
  #       IMAGE_VOTES_COUNT.rank_member(params[:id].to_s, @image.score_like)
  #     rescue Redis::CannotConnectError
  #       @image.downvote_by current_user
  #     end
  #   else
  #     flash[:warning] = 'You already downvoted for this image!'
  #   end
  #   redirect_to root_url
  # end

  def downvote_like
    @image = Image.find(params[:id])
    if @image.likes.where(user_id: current_user.id)
      begin
        Redis.new.set('getstatus', 1)
        Like.delete(Like.where(user_id: current_user.id,image_id: @image.id))
        @image.update_attributes(likes_img: @image[:likes_img] - 1)
        IMAGE_VOTES_COUNT.rank_member(params[:id].to_s, @image.score_like)
      rescue Redis::CannotConnectError
        Like.delete(Like.where(user_id: current_user.id,image_id: @image.id))
        @image.likes_img -= 1
      end
    end
    redirect_to root_url
  end


  private

  def page(options)
    options[:page] || 1
  end

  def page_size(options)
    options[:page_size] || 12
  end
end
