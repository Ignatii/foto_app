class ImagesController < ApplicationController  

  def show
    @image = Image.find(params[:id])
  end

  def create
    if(params.key?(:image))
	@images = current_user.images.build(image: params[:image][:image])    
	if @images.save
	  flash[:success] = "Image updated!"
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
    @images.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
    #redirect_back(fallback_location: root_url)
  end

  def upvote
    @image = Image.find(params[:id])
    @image.upvote_by current_user
    #$redis.set(params[:id].to_s,@image.score)
    debugger
    IMAGE_VOTES_COUNT.rank_member(params[:id].to_s, @image.score,{name: @image[:id]}.to_json)
    redirect_to current_user
  end

  def downvote
    @image = Image.find(params[:id])
    @image.downvote_by current_user
    #$redis.set(params[:id].to_s,@image.score)
    IMAGE_VOTES_COUNT.rank_member(params[:id].to_s, @image.score,{name: @image[:id]}.to_json)
    redirect_to current_user
  end

end
