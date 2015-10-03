class UploadController < ApplicationController

  def index
    @venues = Venue.all
    @works = Work.all
    @delete_work = Work.order(:work_name, :language)
    render :file => 'app/views/upload/uploadfile.html.erb'
  end

  def uploadFile
    Text.all.where(work: params[:work]).delete_all
    data_file = DataFile.new(
      params[:work],
      params[:character_per_line].to_i,
      params[:split_type]
    )
    if data_file.parse(params[:upload])
      redirect_to :controller => 'cast', :action => 'index'
    else
      flash[:notice] = "Script not loaded, check that file is .fdx .rtf or .txt"
      redirect_to :back
    end
  end

end
