class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.integer :work
      t.integer :sequence
      t.integer :element
      t.string :character
      t.string :content_text
      t.string :color
      t.boolean :visibility
      t.timestamps
    end
  end
end
