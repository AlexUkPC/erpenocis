class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    # :registerable,
    :recoverable,
    :rememberable,
    :lockable,
    :validatable,
    :trackable,
    authentication_keys: [:login],
		reset_password_keys: [:login]
  
  validates :username, presence: { message: "nu poate fi gol" }
  validates :username, uniqueness: { message: "trebuie sa fie unic. Cel introdus exista deja in baza de date." }
  validates :username, length: {minimum: 4, message: "trebuie sa aiba minim 4 caractere" }
  validates :email, uniqueness: true
  has_one_attached :profile_picture
  attr_accessor :remove_profile_picture
  after_save { profile_picture.purge if (remove_profile_picture == '1' ) }
  attr_writer :login
  enum role: [:user, :user_achizitii, :user_facturi, :admin]
  # after_initialize :set_default_role, :if => :new_record?

  # def set_default_role
  #   self.role ||= :user
  # end

  def login
    @login || username || email
  end
  def self.find_authenticatable(login)
      where("(username = :value OR email = :value)AND(active = true)", value: login).first
  end
  def self.find_for_database_authentication(conditions)
      conditions = conditions.dup
      login = conditions.delete(:login)
      find_authenticatable(login)
  end
	def self.send_reset_password_instructions(conditions)
    recoverable = find_recoverable_or_init_with_errors(conditions)

    if recoverable.persisted?
    recoverable.send_reset_password_instructions
    end
    recoverable
  end

  def self.find_recoverable_or_init_with_errors(conditions)
      conditions = conditions.dup
      login = conditions.delete(:email).downcase
      recoverable = find_authenticatable(login)

      unless recoverable
      recoverable = new(email: login)
      recoverable.errors.add(:email, login.present? ? :not_found : :blank)
      end
      recoverable
  end
  def profile_picture_url
    @profile_picture_url ||= begin
    hash = Digest::MD5.hexdigest(email)
    "https://www.gravatar.com/avatar/#{hash}?d=mp"
    end
  end
end
