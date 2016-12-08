class Session < ActiveRecord::Base
  validates :user_id, :session_token, presence: true

  belongs_to :user
end
