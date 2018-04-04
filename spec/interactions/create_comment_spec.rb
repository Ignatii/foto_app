require "rails_helper"

RSpec.describe CreateComments do
  let!(:user) { create(:user) }
  let!(:image) { create(:image) }
  let!(:params_true) { { body: 'test', image_id: image.id } }
  let!(:params_false) { { body: '', image_id: image.id } }
  let!(:outcome_true) { CreateComments.run(params: params_true, user: user) }
  let!(:outcome_false) { CreateComments.run(params: params_false, user:user) }

  it 'should be valid' do
   expect(outcome_true.valid?).to be(true)
   expect(outcome_false.valid?).to be(false)
  end

  it 'should return string' do
   expect(outcome_true.result).to match('Comment added')
  end

  it 'should return false' do
   expect(outcome_false.valid?).to be(false)
   expect(outcome_false.errors.full_messages.to_sentence).to match('Comment must not be empty!')
  end
end