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

  # action_item :destroy_visit, only: %i[edit] do
  #   link_to 'Delete', "/admin/visits/#{object.id}", method: :delete
  # end

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
        a.input :destroy, as: :radio
       # unless a.object.new_record?
       a.actions do
         link_to 'Delete', "/admin/visits/#{object.id}", method: :delete
       end
        # a.actions do
        #     # link_to 'Delete',
        #     #         "/admin/visits/#{object.id}",
        #     #         method: :delete
        #     a.action :submit , label: "Delete", url: "/admin/visits/#{object.id}",
        #               method: :delete
        # end
        #end
      end
    end
    f.submit
  end
end
