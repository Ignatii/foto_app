require "rails_helper"

RSpec.describe CreateImages do
  let!(:user) { create(:user) }
  let!(:params_true) { { image: fixture_file_upload('files/index.jpeg', 'image/jpeg'),
                         title_img: 'title',
                         tags: 'tag1',
                         user_id: user.id } }
  let!(:params_false) { { image: File.open("/home/ignatiy/Загрузки/Postman-linux-x64-6.0.10.tar.gz",'r'),
                         title_img: 'title',
                         tags: 'tag1',
                         user_id: user.id } }
  let!(:outcome_true) { CreateImages.run(params: params_true) }
  let!(:outcome_false) { CreateImages.run(params: params_false) }

  it 'should be valid' do
   expect(outcome_true.valid?).to be(true)
   expect(outcome_false.valid?).to be(false)
  end

  it 'should return string' do
   expect(outcome_true.result).to match(Image.new().class)
  end

  it 'should return false' do
   expect(outcome_false.valid?).to be(false)
   expect(outcome_false.errors.full_messages.to_sentence.class).to match("".class)
  end
end