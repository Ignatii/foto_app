require "rails_helper"

RSpec.describe LikeImages do
  let(:user) { create(:user) }
  let(:image) { create(:image) }
  let(:image2) { create(:image, id: 2) }
  let(:like) { create(:like, image_id: image2.id) }
  let(:params_true) { { user: user, image_id: image.id } }
  let(:outcome_true) { LikeImages.run(params_true) }
  let(:params_false) { { user: user, image_id: image2.id } }
  let(:outcome_false) { LikeImages.run(params_false) }

  it 'should be present' do
   expect(outcome_true.present?).to be(true)
   expect(outcome_false.present?).to be(true)
  end
  
  it 'should be valid' do
   expect(outcome_true.valid?).to be(true)
  end

  # it 'should validate required params presence' do
  #  params_true.keys.each do |k|
  #    expect(outcome_true.except(k).errors).to include(k)
  #  end
  #  params_false.keys.each do |k|
  #    expect(outcome_false.except(k).errors).to include(k)
  #  end
  # end

  it 'should return true' do
   expect(outcome_true.result).to be(true)
  end

  it 'should return false' do
   expect(outcome_false.result).to be(false)
  end
end