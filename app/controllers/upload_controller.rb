class UploadController < ApplicationController

  def index
    @venues = Venue.all
    @works = Work.all
    render :file => 'app/views/upload/uploadfile.html.erb'
  end

  def uploadFile
    post = DataFile.save(params[:upload])
    render :text => "File has been uploaded successfully"
  end
    post = DataFile.parse_fd(params[:upload],"Equivocation")
    render :text => "File has been uploaded successfully"

  end


end
