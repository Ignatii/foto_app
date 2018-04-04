require "rails_helper"

RSpec.describe FindImages do
  let!(:user) { create(:user) }
  let!(:image) { create(:image) }
  let!(:image2) { create(:image, id: 2, likes_img: 2, created_at: '2018-03-29 10:55:18') }
  let(:params_data) { { condition_search: '', sort_data: 'true' } }
  let(:params_upvote) { { condition_search: '', sort_upvote: 'true' } }
  let(:outcome_data) { FindImages.run(params: params_data) }
  let(:outcome_upvote) { FindImages.run(params: params_upvote) }
  let(:outcome_list) { ListImages.run! }

  it 'should be valid' do
   expect(outcome_data.valid?).to be(true)
   expect(outcome_upvote.valid?).to be(true)
  end

  it 'should return true' do
   expect(outcome_data.result).to match(outcome_list.reorder(created_at: :DESC))
   expect(outcome_upvote.result).to match(outcome_list.reorder(likes_img: :ASC))
  end

end