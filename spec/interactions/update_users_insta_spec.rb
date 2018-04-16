require 'rails_helper'

RSpec.describe Images::UpdateUsersInsta, vcr: true do
  let!(:user) { create(:user) }
  let(:params_true) { { user: user, token_insta: 'token=gfgsdfr4f' } }
  let(:outcome_true) { Images::UpdateUsersInsta.run(params_true) }
  let(:params_false) { { user: user, token_insta: 'gfgsdfr4f' } }
  let(:outcome_false) { Images::UpdateUsersInsta.run(params_false) }

  it 'should be valid' do
    expect(outcome_true.valid?).to be(true)
  end

  it 'should be invalid' do
    expect(outcome_false.valid?).to be(false)
  end

  it 'should return string' do
    message = 'Your photos from instagram successfully added'
    expect(outcome_true.result).to match(message)
  end

  it 'should return error' do
    expect(outcome_false.valid?).to be(false)
    m = 'Problem with adding your instagram photos. Try later or contact admin'
    expect(outcome_false.errors.full_messages.to_sentence).to match(m)
  end
end
