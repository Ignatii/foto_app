require "rails_helper"

RSpec.describe ShowUsersInsta, vcr: true do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user,id:2, insta_token: '3454545') }
  let!(:params_true) { { user: user } }
  let!(:outcome_true) { VCR.use_cassette('vcr/insta_api') do
                        ShowUsersInsta.run(params_true)
                      end}
  # let!(:params_false) { { user: user2 } }
  # let!(:outcome_false) { ShowUsersInsta.run(params_false) }

  it 'should be valid' do
    expect(outcome_true.valid?).to be(true)
    debugger
  end

  it 'should return true' do
   expect(outcome_true.result.class).to match({ prim: 1 }.class)
  end

  # it 'should return false' do
  #  expect(outcome_false.valid?).to be(false)
  # end
end