class Test < ActiveRecord::Base
  belongs_to :testable, polymorphic: true
  belongs_to :stack
end
