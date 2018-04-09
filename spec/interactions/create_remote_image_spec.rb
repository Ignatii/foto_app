require 'rails_helper'

RSpec.describe CreateRemoteImages, vcr: true do
  let!(:user) { create(:user) }
  let(:params_true) do
    { url_image: { url: 'https://scontent.cdninstagram.com/vp/9225dda2a4739d20fe2a452b6c8491a1/5B6B6405/t51.2885-15/s320x320/e35/21689930_2017148641838602_4835430415567159296_n.jpg' },
      text: 'title #tag',
      insta_tags: %w[tag1,tag2],
      user_id: user.id }
  end
  let(:params_false) do
    { url_image: { url: 'https://scontent.cdninstagram.com/vp/9225dda2a4739d20fe2a452b6c8491a1/5B6B6405/t51.2885-15/s320x320/e35/21689930_2017148641838602_4835430415567159296_n.jpg'},
      text: 'title #tag',
      insta_tags: %w[tag1,tag2],
      user_id: user.id }
  end
  let(:outcome_true) do
    VCR.use_cassette('remote_image') do
      CreateRemoteImages.run(params: params_true)
    end
  end
  let(:outcome_false) do
    VCR.use_cassette('remote_image_invalid') do
      CreateRemoteImages.run(params: params_false)
    end
  end

  it 'should be valid' do
    expect(outcome_true.valid?).to be(true)
    expect(outcome_false.valid?).to be(false)
  end

  it 'should return string' do
    expect(outcome_true.result.class).to match(Image.new.class)
  end

  it 'should return false' do
    expect(outcome_false.valid?).to be(false)
    cl = ''.class
    expect(outcome_false.errors.full_messages.to_sentence.class).to match(cl)
  end
end
