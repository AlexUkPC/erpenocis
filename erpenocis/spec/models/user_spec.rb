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
    it "is invalid if the email is taken" do
      create(:user, email: "adam@example.org" )
      user = User.new
      user.email = "adam@example.org"
      user.username = "adam1"
      user.password = "parola"
      expect(user).not_to be_valid
    end
    it "is invalid if the email is blank" do
      user = create(:user)
      expect(user).to be_valid
      user.email = ""
      expect(user).not_to be_valid
      user.email = nil
      expect(user).not_to be_valid
    end
    it "is invalid if the email looks bogus" do
      user = create(:user)
      expect(user).to be_valid
      user.email = ""
      expect(user).to be_invalid  
      user.email = "foo.bar"
      expect(user).to be_invalid  
      user.email = "foo.bar#example.com"
      expect(user).to be_invalid  
      user.email = "f.o.o.b.a.r@example.com"
      expect(user).to be_valid  
      user.email = "foo+bar@example.com"
      expect(user).to be_valid  
      user.email = "foo.bar@example.co.id"
      expect(user).to be_valid 
    end

    it "is valid when username is unique" do
      user1 = create(:user)
      user = User.new
      user.email = "adam1@example.org"
      user.username = "adam1"
      user.password = "parola"
      expect(user.valid?).to be true 
    end
		it "is invalid if the username is taken" do
      create(:user, username: "adam" )
      user = User.new
      user.email = "adam@example.org"
      user.username = "adam"
      user.password = "parola"
      expect(user).not_to be_valid
    end
    it "is invalid if the username is blank" do
      user = create(:user)
      expect(user).to be_valid
      user.username = ""
      expect(user).not_to be_valid
      user.username = nil
      expect(user).not_to be_valid
    end
    it "is invalid if the username is shorten then 4 characters" do
      user = create(:user)
      expect(user).to be_valid
      user.username = "ada"
      expect(user).to be_invalid
    end
    it "is invalid if the password is shorten then 6 characters" do
      user = create(:user)
      expect(user).to be_valid
      user.password = "p"
      expect(user).to be_invalid
      user.password = "pa"
      expect(user).to be_invalid
      user.password = "pas"
      expect(user).to be_invalid
      user.password = "pass"
      expect(user).to be_invalid
      user.password = "passw"
      expect(user).to be_invalid
      user.password = "passwo"
      expect(user).to be_valid
    end
  end
end
