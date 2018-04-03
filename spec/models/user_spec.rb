require "rails_helper"
require 'vcr'

RSpec.describe User, :type => :model do
  subject { build(:user) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a email" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  describe "Associations" do

    it "has many images" do
      assc = User.reflect_on_association(:images)
      expect(assc.macro).to eq :has_many
    end

    it "has many comments" do
      assc = User.reflect_on_association(:comments)
      expect(assc.macro).to eq :has_many
    end

    it "has many identities" do
      assc = User.reflect_on_association(:identities)
      expect(assc.macro).to eq :has_many
    end
  end
end