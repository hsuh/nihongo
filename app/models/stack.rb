class Stack < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :tests
end
