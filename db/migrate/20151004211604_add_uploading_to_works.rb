class AddUploadingToWorks < ActiveRecord::Migration
  def change
    add_column :works, :uploading, :boolean, :default => false
  end
end
