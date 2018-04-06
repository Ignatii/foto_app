ActiveAdmin.register User do
  remove_filter :images, :comments, :likes, :identities, :created_at, :api_token, :insta_token

  filter :name_cont, label: 'User name', as: :string
  filter :email_cont, label: 'User email', as: :string

  index do
    selectable_column
    column 'User Name', :name
    column 'User Email', :email
    actions defaults: true
  end
  
  show do
    table_for user.images , :class => "index_table", :id => "ingredients" do
      # images = Image.where(user_id: user.id)
      # images.each do |image_table| 
      #   row "#{image_table.title_img}" do
      #     columns do 
            column 'Users Image' do |image|
              link_to image_tag image.image.thumb.url
            end
      #       column defaults: true do |image|
		    #   item 'Reject',  reject_admin_image_path(image), method: :post unless image.rejected?
		    #   item 'Verify', verify_admin_image_path(image), method: :post unless image.verified?
		    # e
            column 'Verify' do |image|
              link_to "Verify", verify_admin_image_path(image) unless image.verified?
            end
            column 'Reject' do |image|

              link_to "Reject", reject_admin_image_path(image) unless image.rejected?
            end
          # end
        # end
      # end
    end
    default_main_content
  end
  

  controller do
    def reject
      image = Image.find_by(id: params[:id])
      Redis.new.set('getstatus', 1)
      IMAGE_VOTES_COUNT.remove_member(params[:id])
      if image.reject!
        CleanImages.perform_at(1.hour.from_now, image.id)
        redirect_to request.referer, notice: 'Image Rejected!'
      else
        redirect_to request.referer, alert: 'Action didnt work!'
      end
      rescue Redis::CannotConnectError
        redirect_to request.referer, alert: 'Image Rejected! Without Redis! Talk with administrator right now!' if image.reject!
    end

    def verify
      image = Image.find_by(id: params[:id])
      Redis.new.set('getstatus', 1)
      IMAGE_VOTES_COUNT.rank_member(params[:id].to_s, image.likes_img)
      if image.rejected?
        scheduled = Sidekiq::ScheduledSet.new.select
        scheduled.map do |job|
          if job.args == Array(params[:id].to_i)
            job.delete
          end
        end.compact
      end
      if image.verify!
        redirect_to request.referer, notice: 'Image Verified! Task deleted!'
      else
        redirect_to request.referer, alert: 'Action didnt work!'
      end
      rescue Redis::CannotConnectError
        redirect_to request.referer, alert: 'Image verified but cant work because Redis is down now' if image.verify!
    end
  end
end
