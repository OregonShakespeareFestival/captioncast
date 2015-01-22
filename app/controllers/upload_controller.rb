class UploadController < ApplicationController

  def index
    @venues = Venue.all
    @works = Work.all
    render :file => 'app/views/upload/uploadfile.html.erb'
  end

  def uploadFile

    Text.all.where(work: params[:work]).delete_all

    post = DataFile.save(params[:upload])
    post = DataFile.parse_fd(params[:upload], params[:work])
    #render :text => "File has been uploaded successfully"
    redirect_to :controller => 'cast', :action => 'index'
  end


end
