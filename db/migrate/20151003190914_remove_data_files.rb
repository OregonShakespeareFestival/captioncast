class RemoveDataFiles < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists? :data_files
      drop_table :data_files
    end 
  end
end
