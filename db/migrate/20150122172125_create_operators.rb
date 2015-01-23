class CreateOperators < ActiveRecord::Migration
  def change
    create_table :operators do |t|
      t.text :name
      t.text :view_attributes
      t.integer :position
      t.timestamps
    end
    add_reference :operators, :work, index: true
  end
end
