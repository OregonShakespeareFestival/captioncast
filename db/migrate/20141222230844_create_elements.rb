class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
	t.string :type
	t.integer :content_text
	t.string :color
      t.timestamps
    end
  end
end
