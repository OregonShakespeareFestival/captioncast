class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.string :element_name
      t.string :element_type
      t.string :color
      t.timestamps
    end
    add_reference :elements, :work, index: true
  end
end
