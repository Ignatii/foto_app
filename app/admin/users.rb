ActiveAdmin.register User do
  remove_filter :images,
                :comments,
                :likes,
                :identities,
                :created_at,
                :api_token,
                :insta_token

  filter :name_cont, label: 'User name', as: :string
  filter :email_cont, label: 'User email', as: :string

  index do
    selectable_column
    column 'User Name', :name
    column 'User Email', :email
    actions defaults: true
  end

  show do
    table_for user.images, class: 'index_table', id: 'ingredients' do
      column 'Users Image' do |image|
        link_to image_tag image.image.thumb.url
      end
      column 'Verify' do |image|
        link_to 'Verify', verify_admin_image_path(image) unless image.verified?
      end
      column 'Reject' do |image|
        link_to 'Reject', reject_admin_image_path(image) unless image.rejected?
      end
    end
    default_main_content
  end

  form do |f|
    f.inputs 'Details' do
      f.input :name
      f.input :email
      f.input :api_token
      f.input :insta_token
      f.input :created_at
      f.input :updated_at
    end
    f.inputs do
      f.has_many :visits,
                 heading: 'Visits',
                 new_record: true do |a|
        a.input :enable, type: :checkboxes
        a.input :country_id,
                as: :select,
                collection: Country.all.map { |u| [u.name_country, u.id] }
      end
    end
    f.submit
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
        mes = 'Image Rejected!Without REDIS!Talk with administrator right now!'
        redirect_to request.referer, alert: mes if image.reject!
    end

    def verify
      image = Image.find_by(id: params[:id])
      Redis.new.set('getstatus', 1)
      IMAGE_VOTES_COUNT.rank_member(params[:id].to_s, image.likes_img)
      if image.rejected?
        scheduled = Sidekiq::ScheduledSet.new.select
        scheduled.map do |job|
          job.delete if job.args == Array(params[:id].to_i)
        end.compact
      end
      if image.verify!
        redirect_to request.referer, notice: 'Image Verified! Task deleted!'
      else
        redirect_to request.referer, alert: 'Action didnt work!'
      end
      rescue Redis::CannotConnectError
        mes = 'Image verified but cant work because Redis is down now'
        redirect_to request.referer, alert: mes if image.verify!
    end
  end
end
