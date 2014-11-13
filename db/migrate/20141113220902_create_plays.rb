class CreatePlays < ActiveRecord::Migration
  def change
    create_table :plays do |t|
      t.string :name
      t.timestamps
    end
  end
end
