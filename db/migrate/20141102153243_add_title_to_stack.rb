class AddTitleToStack < ActiveRecord::Migration
  def change
    add_column :stacks, :title, :string
  end
end
