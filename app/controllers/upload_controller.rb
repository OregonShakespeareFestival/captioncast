class UploadController < ApplicationController

  def index
    render :file => 'app/views/upload/uploadfile.html.erb'
  end

  def uploadFile
    post = DataFile.save(params[:upload])
    post = DataFile.parse_fd(params[:upload],"Equivocation")
    render :text => "File has been uploaded successfully"
  end


end
