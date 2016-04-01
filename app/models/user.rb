# coding: utf-8
class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save { email.downcase! }
  VALID_NAME_REGEX = /\A(\p{Han}+|[A-Za-z ]+)\z/u
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 50 },
            format: { with: VALID_NAME_REGEX }
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  has_many :relationships, foreign_key: "member_id", dependent: :destroy
  has_many :klasses, through: :relationships, source: :klass

  # generate a hash digest of STRING
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # generate a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # remember user in db for session permanent
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # return true if the token and the digest matched
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end

  def join(klass)
    relationships.create(klass_id: klass.id)
  end

  def leave(klass)
    relationships.find_by(klass_id: klass.id).destroy
  end

  def joined?(klass)
    klasses.include?(klass)
  end
end
