ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation
  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  menu label: proc {
                I18n.t(:other,
                       scope: %i[activerecord models admin_user])
              },
       parent: 'tree_1'
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
  action_item :disable_api,
              only: :index,
              # $redis_api.get('api') == 'true'
              if: proc {} do
    link_to('Disable API', 'admin_users/disable', method: :post)
  end

  action_item :enable_api,
              only: :index,
              # $redis_api.get('api') == 'false'
              if: proc {} do

    link_to('Enable API', 'admin_users/enable', method: :post)
  end

  action_item :enable_api,
              only: :index,
              # $redis_api.get('api').nil?
              if: proc {} do

    link_to('Initialize API', 'admin_users/initialize_api', method: :post)
  end

  collection_action :enable, method: :post do
    # $redis_api.set('api', true)
    redirect_to request.referer, notice: 'API Enabled'
  end

  collection_action :disable, method: :post do
    # $redis_api.set('api', false)
    redirect_to request.referer, notice: 'API Disnabled'
  end

  collection_action :initialize_api, method: :post do
    # $redis_api.set('api', true)
    redirect_to request.referer, notice: 'API Initialized'
  end
end
