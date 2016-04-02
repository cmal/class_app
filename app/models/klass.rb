class Klass < ActiveRecord::Base
  has_many :relationships, foreign_key: "klass_id", dependent: :destroy
  has_many :members, through: :relationships, source: :member
  self.per_page = 10
end
