class Question < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :template

      t.timestamps
    end
  end
end
