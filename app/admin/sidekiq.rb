ActiveAdmin.register_page 'Sidekiq' do
  menu label: proc { I18n.t(:sidekiq) },
       url: proc { "#{ENV['REDIRECT_INSTA']}/sidekiq" },
       parent: 'tree'
end
