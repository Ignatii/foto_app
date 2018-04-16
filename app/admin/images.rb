require 'nokogiri'
require 'csv'

ActiveAdmin.register Image do
  permit_params :aasm_state
  config.sort_order = 'position_asc'
  config.per_page = 20
  config.sort_order = 'id_asc'
  config.paginate   = false

  # config.filters = false
  # preserve_default_filters!
  # menu label: I18n.t(:other, scope: %i[activerecord models image])

  remove_filter :comments, :likes, :image, :created_at
  # filter :user, label: 'User'
  # filter :user_name_contains, :as => :string
  filter :title_img_cont

  filter :tags_cont

  filter :created_at
  # filter :user, as: :search_select_filter, url: proc { user_path(:user) },
  #        fields: [:name], display_name: 'name', minimum_input_length: 2,
  #        order_by: 'name_asc'
  # filter :by_user_name_in, label: "User name", as: :string
  # filter :search_comment_in,
  #         label: I18n.t(:title_img_cont,
  #                       scope: %i[active_admin models_db image]),
  #         as: :string
  filter :user_name_cont

  filter :comments_body_cont
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
    column I18n.t(:image_column,
                  scope: %i[active_admin models_db image]) do |image|
      image_tag image.image.thumb.url # , class: 'my_image_size'
    end
    # column 'User ID and name', "#{image.user_id} - #{image.user.name}"
    column I18n.t(:user_id_name,
                  scope: %i[active_admin models_db image]) do |image|
      link_to "#{image.user_id} - #{image.user.name}",
              admin_user_path(image.user_id)
    end
    state_column :aasm_state
    actions defaults: true do |image|
      r = image.rejected?
      v = image.verified?
      item I18n.t(:reject_img,
                  scope: %i[active_admin models_db image]),
           reject_admin_image_path(image), method: :post unless r
      item I18n.t(:vetify_img,
                  scope: %i[active_admin models_db image]),
           verify_admin_image_path(image), style: 'padding-right: 5px',
                                           method: :post unless v
    end
  end

  batch_action :verify do |ids|
    batch_action_collection.find(ids).each do |image|
      image.verify! unless image.verified?
    end
    redirect_to collection_path, notice: 'Selected images has been verified'
  end

  batch_action :reject do |ids|
    batch_action_collection.find(ids).each do |image|
      image.reject! unless image.rejected?
    end
    redirect_to collection_path, notice: 'Selected images has been rejected'
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
    link_to(I18n.t(:reject_img,
                   scope: %i[active_admin models_db image]),
            reject_admin_image_path(image), method: :post)
  end

  action_item :Verify, only: :show,
                       if: proc { image.rejected? || image.unverified? } do
    link_to(I18n.t(:verify_img,
                   scope: %i[active_admin models_db image]),
            verify_admin_image_path(image), method: :post)
  end

  action_item :i_xml, only: :index do
    link_to(I18n.t(:i_xml,
                   scope: %i[active_admin models_db image]),
            'images/xmlimage', method: :post)
  end

  collection_action :xmlimage, method: :post do
    result = Admin::ImagesImport.run(mode: 'xml')
    redirect_to request.referer, notice: 'XML created!' if result.valid?
    redirect_to request.referer, alert: 'Error!' unless result.valid?
  end

  action_item :i_cxv, only: :index do
    link_to(I18n.t(:i_csv,
                   scope: %i[active_admin models_db image]),
            'images/csvimage', method: :post)
  end

  collection_action :csvimage, method: :post do
    result = Admin::ImagesImport.run(mode: 'csv')
    redirect_to request.referer, notice: 'CSV created!' if result.valid?
    redirect_to request.referer, alert: 'Error!' unless result.valid?
  end

  action_item :i_xls, only: :index do
    link_to(I18n.t(:i_xls,
                   scope: %i[active_admin models_db image]),
            'images/xlsimage', method: :post)
  end

  collection_action :xlsimage, method: :post do
    result = Admin::ImagesImport.run(mode: 'xls')
    redirect_to request.referer, notice: 'XLS created!' if result.valid?
    redirect_to request.referer, alert: 'Error!' unless result.valid?
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
      result = Admin::ImageReject.run(image_id: params[:id])
      redirect_to request.referer, notice: 'Image Rejected!' if result.valid?
      error = result.errors.full_messages.to_sentence
      redirect_to request.referer, alert: error unless result.valid?
    end

    def verify
      result = Admin::ImageVerify.run(image_id: params[:id])
      message_valid = 'Image Verified! Task deleted!'
      redirect_to request.referer, notice: message_valid if result.valid?
      error = result.errors.full_messages.to_sentence
      redirect_to request.referer, alert: error unless result.valid?
    end
  end
end
