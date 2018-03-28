ActiveAdmin.register Image do
  permit_params :aasm_state

  member_action :reject, method: :post, only: :index do
  end

  member_action :verify, method: :post, only: :index do
  end

  index do
    column :id
    column 'Image' do |image|
      image_tag image.image.thumb.url # , class: 'my_image_size'
    end
    column 'User ID', :user_id
    column 'State', :aasm_state
    actions defaults: true do |image|
      item 'Reject',  reject_admin_image_path(image), method: :post unless image.rejected?
      item 'Verify', verify_admin_image_path(image), method: :post unless image.verified?
    end
  end

  show do
    attributes_table do
      row :image do |image|
        image_tag image.image.thumb_lg.url
      end
    end
    default_main_content
  end

  action_item :Reject, only: :show,
                       if: proc { image.verified? || image.unverified? } do
    link_to('Reject', reject_admin_image_path(image), method: :post)
  end

  action_item :Verify, only: :show,
                       if: proc { image.rejected? || image.unverified? } do
    link_to('Verify', verify_admin_image_path(image), method: :post)
  end

  controller do
    def update
      @image = Image.find(params[:id])
      Image.update(@image.id, params[:image][:aasm_state])
      # @image.update_attributes(aasm_state: params[:image][:aasm_state])
      @image.reject! if @image.rejected?
      redirect_to request.referer
    end

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
