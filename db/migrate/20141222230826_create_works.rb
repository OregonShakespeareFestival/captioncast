class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
	t.string :name
	t.string :venue
      t.timestamps
    end
  end
end
