ActiveAdmin.register Visit do
  permit_params :user_id, :country_id, :created_at, :updated_at
  # index do
  #   model = I18n.t('activerecord')[:models][:attributtes][:visit]
  #   column :id
  #   column model[:enable], :enable
  #   column model[:user_id], :user_id
  #   column model[:country_id], :country_id
  # end
  controller do
    def destroy
      @visit = Visit.find(params[:id])
      @visit.destroy
      redirect_to request.referer
    end
  end
end
