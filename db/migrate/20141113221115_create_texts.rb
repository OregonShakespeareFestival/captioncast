class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.integer :sequence
      t.text :content_text
      t.string :color_override
      t.boolean :visibility
      t.timestamps
    end
    add_reference :texts, :work, index: true
    add_reference :texts, :element, index: true
  end
end
