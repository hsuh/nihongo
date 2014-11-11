class CreateTest < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.integer :testable_id
      t.integer :stack_id
      t.integer :right_count
      t.integer :wrong_count

      t.timestamps
    end
  end
end
