class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.integer :position
      t.string :content_type
      t.string :content_text
      t.string :color
      t.boolean :visibility
      t.timestamps
    end
  end
end
