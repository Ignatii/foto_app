class ImagesController < ApplicationController  

  def show
    @image = Image.find(params[:id])
  end

  def create
    if(params.key?(:image))
	@images = current_user.images.build(image: params[:image][:image])    
	if @images.save
	  flash[:success] = "Image updated!"
          IMAGE_VOTES_COUNT.rank_member(@images.id.to_s, 0)
	  redirect_to current_user
	else
	  flash[:warning] = "Image do not updated!"
	  redirect_to root_url
	end
    else
      flash[:warning] = "Choose image!"
      redirect_to current_user
    end
  end

  def destroy
    @image.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
    #redirect_back(fallback_location: root_url)
  end

  def upvote
    @image = Image.find(params[:id])
    if !current_user.voted_up_on?(@image)
    	@image.upvote_by current_user
    	#$redis.set(params[:id].to_s,@image.score)
    	IMAGE_VOTES_COUNT.rank_member(params[:id].to_s, @image.score)
    else
        flash[:warning] = "You already voted for this image!"
    end
    redirect_to root_url
  end

  def downvote
    @image = Image.find(params[:id])
    if !current_user.voted_down_on?(@image)
      @image.downvote_by current_user
      #$redis.set(params[:id].to_s,@image.score)
      IMAGE_VOTES_COUNT.rank_member(params[:id].to_s, @image.score)
    else
      flash[:warning] = "You already downvoted for this image!"
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
