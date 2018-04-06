require 'nokogiri'
require 'csv'

ActiveAdmin.register Image do
  permit_params :aasm_state
  config.sort_order = 'position_asc'
  config.per_page = 20
  # config.filters = false
  # preserve_default_filters!
  remove_filter :comments, :likes, :image, :created_at
  # filter :user, label: 'User'
  # filter :user_name_contains, :as => :string
  filter :title_img, label: 'Title'
  filter :tags, label: 'Tags'
  filter :created_at, label: 'Created At', as: :date_time_picker
  # filter :user, as: :search_select_filter, url: proc { user_path(:user) },
  #        fields: [:name], display_name: 'name', minimum_input_length: 2,
  #        order_by: 'name_asc'
  # filter :by_user_name_in, label: "User name", as: :string
  # filter :search_name_in,
  #         label: 'User name',
  #         as: :string
  filter :user_name_cont, label: 'User name', as: :string
  filter :comments_body_cont, label: 'Comment contains', as: :string
  # filter :comments_id, label: 'Comment_id', as: :numeric
  # filter :search_comment_in,
  #         label: 'Search by comment',
  #         as: :string

  member_action :reject, method: :post, only: :index do
  end

  member_action :verify, method: :post, only: :index do
  end

  index do
    sortable_handle_column
    selectable_column
    # column :id
    column 'Image' do |image|
      image_tag image.image.thumb.url # , class: 'my_image_size'
    end
    # column 'User ID and name', "#{image.user_id} - #{image.user.name}"
    column 'User ID and name' do |image|
      "#{image.user_id} - #{image.user.name}"
    end
    state_column 'State', :aasm_state
    #state_column(:aasm_state, states: { destroyed: "rejected" , created: 'verified'})
    actions defaults: true do |image|
      item 'Reject',  reject_admin_image_path(image), method: :post unless image.rejected?
      item 'Verify', verify_admin_image_path(image), method: :post unless image.verified?
    end
  end
  
  batch_action :verify do |ids|
    batch_action_collection.find(ids).each do |image|
      image.verify! unless image.verified?
    end
    redirect_to collection_path, notice: "Selected images has been verified"
  end

  batch_action :reject do |ids|
    batch_action_collection.find(ids).each do |image|
      image.reject! unless image.rejected?
    end
    redirect_to collection_path, notice: "Selected images has been rejected"
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
  
  action_item do
    link_to('Import XML', 'images/xmlimage', :method => :post) 
  end

  collection_action :xmlimage, :method => :post do
    @images_xml = Image.all.order(:likes_img)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.images {
          @images_xml.each do |image|
            user = image.user
            xml.image {
              xml.id image.id
              xml.image_name image.image
              xml.created_at image.created_at
              xml.state image.aasm_state
              xml.title image.title_img
              xml.tags image.tags
              xml.likes image.likes_img
              xml.user{
                xml.user_id user.id
                xml.name_user user.name
                xml.email user.email
              }
              xml.comments{
                comments = image.comments
                if comments.count > 0
                  comments.each do |comment|
                    xml.comment_xml{
                      xml.comment_id comment.id
                      xml.user_id comment.user_id
                      xml.body comment.body
                      xml.created_at comment.created_at
                    }
                  end
                end
              }
            }
          end
        }
      end
      path = Rails.root.join('public', 'import', 'images.xml')
      content = builder.to_xml
      File.open(path, "w+") do |f|
        f.write(content)
      end
      redirect_to request.referer, notice: 'XML created!'
  end

  action_item do
    link_to('Import CXV', 'images/csvimage', :method => :post) 
  end

  collection_action :csvimage, :method => :post do
    @images_csv = Her.all # Image.joins(:user, :comments).order(:likes_img).select ('images.*,users.*, users.id as id_u, comments.*, comments.id as id_c, comments.user_id as c_id_u')
    path = Rails.root.join('public', 'import', 'images.csv')
    CSV.open(path, "wb") do |csv|
      csv << @images_csv.attribute_names
      @images_csv.each do |image|
        csv << image.attributes.values
      end
    end
    redirect_to request.referer, notice: 'CSV created!'
  end

  action_item do
    link_to('Import Excel', 'images/xlsimage', :method => :post) 
  end

  collection_action :xlsimage, :method => :post do
    @images_xls = Her.all # Image.joins(:user, :comments).order(:likes_img).select ('images.*,users.*, users.id as id_u, comments.*, comments.id as id_c, comments.user_id as c_id_u')
    path = Rails.root.join('public', 'import', 'images.xls')
    File.open(path, "w+") do |f|
      f.write(@images_xls.to_a.to_xls(:only => [:idd, :image,
                                           :i_u_id, :i_created_at,
                                           :state, :title,
                                           :tags, :likes,
                                           :u_id, :name,
                                           :email, :c_id,
                                           :comment_text, :c_created_at]).force_encoding('utf-8').encode)
    end
    redirect_to request.referer, notice: 'XLS created!'
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
