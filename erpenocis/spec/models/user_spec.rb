require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#valid?" do
    it "is valid when email is unique" do
      user1 = create(:user)
      user = User.new
      user.email = "adam@example.org"
      user.username = "adam1"
      user.password = "parola"
      expect(user.valid?).to be true 
    end
    it "is valid when username is unique" do
      user1 = create(:user)
      user = User.new
      user.email = "adam1@example.org"
      user.username = "adam1"
      user.password = "parola"
      expect(user.valid?).to be true 
    end
		it "is invalid if the email is taken" do
      create(:user, email: "adam@example.org" )
      user = User.new
      user.email = "adam1@example.org"
      user.username = "adam1"
      user.password = "parola"
      expect(user).not_to be_valid
    end
		it "is invalid if the username is taken" do
      create(:user, username: "adam" )
      user = User.new
      user.email = "adam@example.org"
      user.username = "adam"
      user.password = "parola"
      expect(user).not_to be_valid
    end
  end
end
