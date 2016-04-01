class Relationship < ActiveRecord::Base
  belongs_to :klass
  belongs_to :member, class_name: "User"
  validates :klass_id, presence: true
  validates :member_id, presence: true
end
