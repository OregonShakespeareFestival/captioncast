class AddDefaultValues < ActiveRecord::Migration
  def change
    change_column :works, :characters_per_line, :integer, :default => 0
  end
end
