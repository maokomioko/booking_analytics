class WubookAuth
  include MongoWrapper
  include ActiveModel::SecurePassword

  belongs_to :user

  field :user_id, type: String
  index({ user_id: 1 }, { background: true })

  field :login, type: String
  field :password_digest, type: String
  field :lcode, type: String

  has_secure_password
end
