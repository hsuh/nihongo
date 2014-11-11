class AddTestableTypeToTest < ActiveRecord::Migration
  def change
    add_column :tests, :testable_type, :string
  end
end
