ActiveAdmin.register Country do
  permit_params :name_country, :created_at, :updated_at,
                visits_attributes: %i[id user_id enable _destroy]
  # accepts_nested_attributes_for :visits, allow_destroy: true
  show do
    default_main_content

    panel 'Table of Visits' do
      table_for country.visits do
        column 'Users' do |visit|
          User.find_by(id: visit.user_id).name
        end
      end
    end
  end

  form do |f|
    f.inputs 'Details' do
      f.input :name_country
      f.input :created_at
      f.input :updated_at
    end
    f.inputs do
      f.has_many :visits,
                 heading: 'Visits',
                 allow_destroy: true,
                 new_record: true do |a|
        a.input :enable, type: :checkboxes
        a.input :user_id,
                as: :select,
                collection: User.all.map { |u| [u.name, u.id] }
        unless a.object.new_record?
          a.button do
            link_to 'Delete',
                    delete_admin_visit_path(:id),
                    method: :destroy
          end
        end
      end
    end
    f.submit
  end
end
