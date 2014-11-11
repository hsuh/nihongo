class Answer < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :word
      t.belongs_to :supplier

      t.timestamps
    end
  end
end
