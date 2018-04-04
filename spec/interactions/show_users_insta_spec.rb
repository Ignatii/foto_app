require "rails_helper"

RSpec.describe ShowUsersInsta, vcr: true do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user,id:2, insta_token: '3454545') }
  let(:params_true) { { user: user } }
  let(:outcome_true) do
    VCR.use_cassette('insta_api') do
      ShowUsersInsta.run(params_true)
    end
  end
  let(:params_false) { { user: user2 } }
  let(:outcome_false) do
    VCR.use_cassette('insta_api_invalid') do
      ShowUsersInsta.run(params_false)
    end
  end

  it 'should be valid' do
    expect(outcome_true.valid?).to be(true)
    expect(outcome_false.valid?).to be(false)
  end

  it 'should return true' do
   expect(outcome_true.result.class).to match([a:1].class)
  end

  it 'should return false' do
    expect(outcome_false.valid?).to be(false)
    expect(outcome_false.errors.full_messages.to_sentence.class).to be(''.class)
  end
end