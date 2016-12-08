class User < ActiveRecord::Base
  validates :username, uniqueness: true
  validates :username, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password, :device

  after_initialize :ensure_session_token

  has_many :cats

  has_many :rental_requests,
    foreign_key: :user_id,
    class_name: :CatRentalRequest

  has_many :sessions

  def self.find_by_credentials(username, pw)
    user = User.find_by(username: username)
    return user if user && user.is_password?(pw)
    nil
  end

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end

  def is_password?(pw)
    BCrypt::Password.new(password_digest).is_password?(pw)
  end

  def device=(device)
    @device = device
  end

  def generate_session_token
    token = SecureRandom.urlsafe_base64(128)
    Session.create(session_token: token, user_id: self.id, device: @device)
  end

  def reset_session_token!
    Session.find_by(device: @device).destroy
  end

  def ensure_session_token
    generate_session_token unless Session.exists?(device: @device)
  end

end
