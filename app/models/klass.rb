class Klass < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 255 },
            uniqueness: true
  has_many :relationships, foreign_key: "klass_id", dependent: :destroy
  has_many :members, through: :relationships, source: :member
  self.per_page = 15
end
