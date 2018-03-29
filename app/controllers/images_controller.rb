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
      hash_params = {img: params[:image][:image],
                    user: current_user,
                    title: params[:image][:title_img],
                    tags: params[:image][:tags]}
      result = CreateImages.run(params_img: hash_params)
      if result.result
        flash[:success] = 'Image uploaded!Wait moderation :)'
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
      hash_params = {img_url: params["url_image"]["url"],
                    user: current_user,
                    title: params[:text],
                    tags: params["insta_tags"]}
      result = CreateRemoteImages.run(params_img: hash_params)
      if result.result
        flash[:success] = 'Image uploaded from Instagram!Wait moderation :)'
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
    hash_params = {image: @image,user: current_user}
    result = LikeImages.run(params_img: hash_params)
    flash[:warning] = 'You already voted for this image!' unless result.result

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
        @image.update_attributes(likes_img: @image[:likes_img] - 1) if @image[:likes_img] > 0
        IMAGE_VOTES_COUNT.rank_member(params[:id].to_s, @image.score_like)
      rescue Redis::CannotConnectError
        Like.delete(Like.where(user_id: current_user.id,image_id: @image.id))
        @image.update_attributes(likes_img: @image[:likes_img] - 1) if @image[:likes_img] > 0
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
