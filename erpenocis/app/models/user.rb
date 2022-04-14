class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable,
    authentication_keys: [:login],
		reset_password_keys: [:login]

  attr_writer :login
  enum role: [:user, :user_achizitii, :user_facturi, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  def login
    @login || username || email
  end
  def self.find_authenticatable(login)
      where("username = :value OR email = :value", value: login).first
  end
  def self.find_for_database_authentication(conditions)
      conditions = conditions.dup
      login = conditions.delete(:login).downcase
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
      login = conditions.delete(:login).downcase
      recoverable = find_authenticatable(login)

      unless recoverable
      recoverable = new(login: login)
      recoverable.errors.add(:login, login.present? ? :not_found : :blank)
      end
      recoverable
  end
end
