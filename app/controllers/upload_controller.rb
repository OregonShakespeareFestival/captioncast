class UploadController < ApplicationController
<<<<<<< HEAD
=======

>>>>>>> ea52836601a9a04c2e8e0b648beaa7895d80a89e
  def index
    render :file => 'app/views/upload/uploadfile.html.erb'
  end

  def uploadFile
    post = DataFile.save(params[:upload])
<<<<<<< HEAD
    render :text => "File has been uploaded successfully"
  end
=======
    post = DataFile.parse_fd(params[:upload],"Equivocation")
    render :text => "File has been uploaded successfully"
  end


>>>>>>> ea52836601a9a04c2e8e0b648beaa7895d80a89e
end
