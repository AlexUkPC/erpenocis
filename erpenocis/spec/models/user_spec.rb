# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(TRUE)
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer
#  sign_in_count          :integer          default(0), not null
#  unlock_token           :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
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
