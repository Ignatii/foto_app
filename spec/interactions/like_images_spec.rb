require "rails_helper"

RSpec.describe LikeImages do
  let!(:user) { create(:user) }
  let!(:image) { create(:image) }
  let!(:image2) { create(:image, id: 2) }
  let!(:like) { create(:like, image_id: image2.id) }
  let!(:params_true) { { user: user, image_id: image.id } }
  let!(:outcome_true) { LikeImages.run(params_true) }
  let!(:params_false) { { user: user, image_id: image2.id } }
  let!(:outcome_false) { LikeImages.run(params_false) }

  it 'should be valid' do
   expect(outcome_true.valid?).to be(true)
   expect(outcome_false.valid?).to be(false)
  end

  it 'should return true' do
   expect(outcome_true.result.class).to match(image.class)
  end

  it 'should return false' do
   expect(outcome_false.valid?).to be(false)
   expect(outcome_false.errors.full_messages.to_sentence).to match('You already voted for this photo!')
  end
end