class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.integer :sequence
      t.string :content_text
      t.string :color_override
      t.boolean :visibility
      t.timestamps
    end
  end
end
