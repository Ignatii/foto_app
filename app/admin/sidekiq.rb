ActiveAdmin.register_page 'Sidekiq' do
  menu label: proc { I18n.t(:sidekiq) },
       # url: proc { "#{ENV['REDIRECT_INSTA']}/sidekiq" },
       # html_options: { target: '_blank' },
       parent: 'tree_1'

  content do
    render partial: 'sidekiq'
  end
end
