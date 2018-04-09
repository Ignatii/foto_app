require 'rails_helper'

RSpec.describe Image, type: :model do
  subject { build(:image) }

  it 'is valid with valid attributes' do
    # user = create(:user)
    expect(subject).to be_valid
  end

  it 'is not valid without a image' do
    subject.image = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a user' do
    subject.user_id = nil
    expect(subject).to_not be_valid
  end

  it { should belong_to(:user) }

  it { should have_many(:comments).dependent(:destroy) }

  it { should have_many(:likes).dependent(:destroy) }
end
