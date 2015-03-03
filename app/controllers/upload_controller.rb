class UploadController < ApplicationController

  def index
    @venues = Venue.all
    @works = Work.all
    @delete_work = Work.order(:work_name, :language)
    render :file => 'app/views/upload/uploadfile.html.erb'
  end

  def uploadFile

    Text.all.where(work: params[:work]).delete_all

    post = DataFile.save(params[:upload])
    post = DataFile.parse_fd(params[:upload], params[:work], params[:character_per_line], params[:split_type])
    #render :text => "File has been uploaded successfully"
    redirect_to :controller => 'cast', :action => 'index'
  end


end
