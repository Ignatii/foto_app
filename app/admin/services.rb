ActiveAdmin.register_page 'Service' do
 menu label: -> { I18n.t(:menu_cusotm,
                         scope: [:active_admin],
                         locale: I18n.locale)
                }, id: 'tree'
end
