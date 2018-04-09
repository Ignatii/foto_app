ActiveAdmin.register Visit do
  permit_params :user_id, :country_id, :created_at, :updated_at
end
