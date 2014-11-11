class AddStackIdToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :stack_id, :integer
  end
end
