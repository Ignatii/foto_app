class ImagesController < ProxyController
  # include RevealBannedUser
  skip_before_action :verify_authenticity_token
  def show
    @image = Image.find(params[:id])
  end

  def create
    if params.key?(:image)
      @images = current_user.images.build(image: params[:image][:image])
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
    redirect_to "images/share/#{params[:id]}"
  end
  
  def create_remote
    if params.key?(:url_image)
      @images = current_user.images.build(remote_image_url: params["url_image"]["url"])
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

  def upvote
    @image = Image.find(params[:id])
    if !current_user.voted_up_on?(@image)
      # @image.upvote_by current_user
      # $redis.set(params[:id].to_s,@image.score)
      begin
        Redis.new.set('getstatus', 1)
        @image.upvote_by current_user
        IMAGE_VOTES_COUNT.rank_member(@image.id.to_s, @image.score)
      rescue Redis::CannotConnectError
        @image.upvote_by current_user
      end
    else
      flash[:warning] = 'You already voted for this image!'
    end
    # inputs = {:id_image => params[:id], :id_user => current_user.id}
    # @upvote = UpvoteImage.run(inputs)
    # flash[:warning] = @upvote
    redirect_to root_url
  end

  def downvote
    @image = Image.find(params[:id])
    if !current_user.voted_down_on?(@image)
      begin
        Redis.new.set('getstatus', 1)
        @image.downvote_by current_user
        IMAGE_VOTES_COUNT.rank_member(params[:id].to_s, @image.score)
      rescue Redis::CannotConnectError
        @image.downvote_by current_user
      end
    else
      flash[:warning] = 'You already downvoted for this image!'
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
