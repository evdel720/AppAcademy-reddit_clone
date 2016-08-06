require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryGirl.build(:user) }

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password_digest) }
  # it do
  #   should validate_length_of(:password).is_at_least(6)
  #   should allow_value(nil).for(:password)
  # end
  it { should have_many(:subs) }
  it { should have_many(:comments) }

  it "creates a password digest when a password is given" do
    expect(user.password_digest).to_not be_nil
  end

  it "creates a session token before validation" do
    user.valid?
    expect(user.session_token).to_not be_nil
  end

  describe '#is_password?' do
    it "returns true for the right password" do
      expect(user.is_password?("12345678")).to be(true)
    end
    it "returns false for the wrong password" do
      expect(user.is_password?("45678")).to be(false)
      expect(user.is_password?("")).to be(false)
    end
  end

  describe "#reset_session_token" do
    it "resets user's session token" do
      old_session_token = user.session_token
      user.reset_session_token
      expect(user.session_token).not_to eq(old_session_token)
    end

    it "returns user's new session_token" do
      expect(user.reset_session_token).to eq(user.session_token)
    end
  end

  describe "::find_by_credentials" do
    before do
      user.save!
    end
    context "with valid inputs" do
      it "returns the correspending user object" do
        returned_user = User.find_by_credentials("first", "12345678")
        expect(returned_user).to eq(user)
      end
    end

    context "with invalid inputs" do
      it "returns nil if the user doesn't exist" do
        returned_user = User.find_by_credentials("second", "12345678")
        expect(returned_user).to be(nil)
      end

      it "returns nil if the password is invalid" do
        returned_user = User.find_by_credentials("first", "password")
        expect(returned_user).to be(nil)
      end
    end
  end
end
