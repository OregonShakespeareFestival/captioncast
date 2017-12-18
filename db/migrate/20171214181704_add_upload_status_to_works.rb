class AddUploadStatusToWorks < ActiveRecord::Migration
  def change
    add_column :works, :upload_status, :string, :default => "Uploading"
    # remove the upload column, because it won't be needed anymore.
    remove_column :works, :uploading
  end
end
