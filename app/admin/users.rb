ActiveAdmin.register User do
  permit_params visits_attributes: %i[user_id enable]
  remove_filter :images,
                :comments,
                :likes,
                :identities,
                :created_at,
                :api_token,
                :insta_token
  filter :name_cont
  # label: I18n.t(:name_filter, scope: %i[active_admin models_db user]),
  # as: :string
  filter :email_cont
  # label: I18n.t(:email_filter, scope: %i[active_admin models_db user]),
  # as: :string
  index do
    selectable_column
    column :name
    column :email
    column I18n.t(:amount,
                  scope: %i[active_admin models_db user]) do |user|
      link_to user.images.count.to_s,
              admin_images_path(q: { user_id_eq: user.id })
    end
    actions defaults: true
  end

  show do
    table_for user.images, class: 'index_table', id: 'ingredients' do
      column I18n.t(:users_image,
                    scope: %i[active_admin models_db user]) do |image|
        link_to image_tag image.image.thumb.url
      end
      column I18n.t(:verify,
                    scope: %i[active_admin models_db user]) do |image|
        link_to I18n.t(:verify,
                       scope: %i[active_admin models_db user]),
                verify_admin_image_path(image) unless image.verified?
      end
      column I18n.t(:reject,
                    scope: %i[active_admin models_db user]) do |image|
        link_to I18n.t(:reject,
                       scope: %i[active_admin models_db user]),
                reject_admin_image_path(image) unless image.rejected?
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
                 heading: I18n.t(:other,
                                 scope: %i[activerecord models visit]),
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
      result = Admin::ImageReject.run(image_id: params[:id])
      redirect_to request.referer, notice: 'Image Rejected!' if result.valid?
      error = result.errors.full_messages.to_sentence
      redirect_to request.referer, alert: error unless result.valid?
    end

    def verify
      result = Admin::ImageVerify.run(image_id: params[:id])
      message_valid = Image Verified! Task deleted!
      redirect_to request.referer, notice: message_valid if result.valid?
      error = result.errors.full_messages.to_sentence
      redirect_to request.referer, alert: error unless result.valid?
    end
  end
end
