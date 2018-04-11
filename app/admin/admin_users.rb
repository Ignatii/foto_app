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
  begin
  action_item :disable_api,
              only: :index,
              if: proc { $redis_api.get('api') == 'true' } do
    link_to('Disable API', 'admin_users/disable', method: :post)
  end

  action_item :enable_api,
              only: :index,
              if: proc { $redis_api.get('api') == 'false' } do

    link_to('Enable API', 'admin_users/enable', method: :post)
  end

  action_item :enable_api,
              only: :index,
              if: proc { $redis_api.get('api').nil? } do

    link_to('Initialize API', 'admin_users/initialize_api', method: :post)
  end

  collection_action :enable, method: :post do
    $redis_api.set('api', true)
    redirect_to request.referer, notice: 'API Enabled'
  end

  collection_action :disable, method: :post do
    $redis_api.set('api', false)
    redirect_to request.referer, notice: 'API Disnabled'
  end

  collection_action :initialize_api, method: :post do
    $redis_api.set('api', true)
    redirect_to request.referer, notice: 'API Initialized'
  end
  rescue Redis::CannotConnectError
  end
end
