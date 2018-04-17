ActiveAdmin.register Country do
  permit_params :name_country, :created_at, :updated_at,
                visits_attributes: %i[id user_id enable _destroy]
  menu label: proc {
                I18n.t(:other,
                       scope: %i[activerecord models country])
              },
       parent: 'tree_1'
  remove_filter :visits, :users

  show do
    default_main_content

    panel I18n.t(:table_visit, scope: %i[active_admin models_db country]) do
      table_for country.visits do
        column I18n.t(:users,
                      scope: %i[active_admin models_db country]) do |visit|
          User.find_by(id: visit.user_id).name
        end
      end
    end
  end
  index do
    sortable_handle_column
    selectable_column
    column :id
    column :name_country do |country|
      I18n.t(country.name_country.downcase.to_sym,
             scope: %i[countries])
    end
  end

  form do |f|
    f.inputs I18n.t(:details, scope: %i[active_admin models_db country]) do
      f.input :name_country
      f.input :created_at
      f.input :updated_at
    end
    f.inputs do
      f.has_many :visits,
                 heading: I18n.t(:visits,
                                 scope: %i[active_admin models_db country]),
                 allow_destroy: true,
                 new_record: true do |a|
        a.input :enable, type: :checkboxes
        a.input :user_id,
                as: :select,
                collection: User.pluck(:name, :id)
        a.actions do
          link_to I18n.t(:delete,
                         scope: %i[active_admin]),
                  delete_admin_visits(object.id), method: :delete
        end
      end
    end
    f.submit
  end
end
