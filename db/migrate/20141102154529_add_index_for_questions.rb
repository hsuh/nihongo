class AddIndexForQuestions < ActiveRecord::Migration
  add_index :questions, [:stack_id]
end
