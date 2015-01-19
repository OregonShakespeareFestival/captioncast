class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :name
      t.timestamps
      t.string :language
    end
    add_reference :works, :venue, index: true
  end
end
