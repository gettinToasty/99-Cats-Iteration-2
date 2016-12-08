class User < ActiveRecord::Base
  validates :username, :session_token, uniqueness: true
  validates :username, :session_token, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password

  after_initialize :ensure_session_token

  has_many :cats

  has_many :rental_requests,
    foreign_key: :user_id,
    class_name: :CatRentalRequest

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

  def generate_session_token
    SecureRandom.urlsafe_base64(128)
  end

  def reset_session_token!
    self.session_token = generate_session_token
    self.save
  end

  def ensure_session_token
    self.session_token ||= generate_session_token
  end

end
