module ActAsTestable
   extend ActiveSupport::Concern
   included do
     has_one :test, as: :testable, dependent: :destroy
     after_create :create_matching_test

     private
     def create_matching_test
       Test.create!(testable: self, stack_id: self.stack.id)
     end
   end
end
