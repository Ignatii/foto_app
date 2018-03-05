ActiveAdmin.register Image do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
permit_params :aasm_state, :image
  Image.aasm.events.each do |aasm_event|
    action = aasm_event.name
    member_action action do
      @image = Image.find(params[:id])
      @image.send(action.to_s + "!")
      redirect_to admin_collection_object_path(@image)
    end
  end

end
