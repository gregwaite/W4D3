# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :user_name, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :session_token, presence: true, uniqueness: true
  before_validation :ensure_session_token


  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def self.find_by_credentials(user_name, password)
     user = User.find_by(user_name: user_name) 
     if user && self.is_password?(password)  #this might break, check here first--check user.is_password?(password)
       user
     else
      nil
     end
  end 

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)  
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

end

  