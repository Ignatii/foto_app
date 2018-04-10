ActiveAdmin.register Visit do
  permit_params :user_id, :country_id, :created_at, :updated_at

  controller do
    def destroy
      @visit = Visit.find(params[:id])
      @visit.destroy
      redirect_to request.referer
    end
  end
end
