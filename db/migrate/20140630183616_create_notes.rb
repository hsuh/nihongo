class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :kanji
      t.text :kana
      t.text :phrase
      t.text :meaning

      t.timestamps
    end
  end
end
