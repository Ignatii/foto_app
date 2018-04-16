require 'rails_helper'

RSpec.describe FindImages do
  let!(:user) { create(:user) }
  let!(:image) { create(:image) }
  let!(:image2) do
    create(:image,
           id: 2,
           likes_img: 2,
           created_at: '2018-03-29 10:55:18')
  end
  let(:params_data) { { condition_search: '', sort_data: 'true' } }
  let(:params_upvote) { { condition_search: '', sort_upvote: 'true' } }
  let(:outcome_data) { Images::List.run(params: params_data) }
  let(:outcome_upvote) { Images::List.run(params: params_upvote) }
  let(:outcome_list) { Images::List.run( a: '' ) }

  it 'should be valid' do
    vexpect(outcome_data.valid?).to be(true)
    vexpect(outcome_upvote.valid?).to be(true)
  end

  it 'should return true' do
    cr_at = outcome_list.reorder(created_at: :DESC)
    vexpect(outcome_data.result).to match(cr_at)
    likes = outcome_list.reorder(likes_img: :ASC)
    vexpect(outcome_upvote.result).to match(likes)
  end
end
