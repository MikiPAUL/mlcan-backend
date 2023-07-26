class User < ApplicationRecord
  has_many :activities
  has_many :comments
  has_many :activity
  has_many :activity_repair_lists
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :doorkeeper

  enum status: {active:0, inactive:1}
  enum role: {admin:0, employee:1}

  def self.authenticate!(email, password)
    user = find_by(email: email.downcase)
    user if user&.valid_password?(password)
  end
end
