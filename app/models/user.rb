class User < ActiveRecord::Base
  validations :username, :session_token, uniqueness: true
  validations :username, :session_token, :password_digest, presence: true
  validations :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password

  after_initialize :ensure_session_token

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
