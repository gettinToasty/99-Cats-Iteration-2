class User < ActiveRecord::Base
  validates :username, uniqueness: true
  validates :username, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password, :device

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

end
