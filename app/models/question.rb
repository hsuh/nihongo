class Question < ActiveRecord::Base
  has_one :answer, dependent: :destroy
  belongs_to :stack

  validate :stack_id, presence: true

  include ActAsTestable
end
