require "rails_helper"

RSpec.describe UpdateUsersInsta, vcr: true do
  let!(:user) { create(:user) }
  let(:params_true) { { user: user, token_insta: 'token=gfgsdfr4f' } }
  let(:outcome_true) { UpdateUsersInsta.run(params_true) }
  let(:params_false) { { user: user, token_insta: 'gfgsdfr4f' } }
  let(:outcome_false) { UpdateUsersInsta.run(params_false) }

  it 'should be valid' do
    expect(outcome_true.valid?).to be(true)
  end

  it 'should be invalid' do
    expect(outcome_false.valid?).to be(false)
  end

  it 'should return string' do
   expect(outcome_true.result).to match('Your photos from instagram successfully added')
  end

  it 'should return error' do
   expect(outcome_false.valid?).to be(false)
   expect(outcome_false.errors.full_messages.to_sentence).to match('Problem with adding your instagram photos. Try later or contact admin')
  end
end