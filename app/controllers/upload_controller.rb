class UploadController < ApplicationController

  def index
    @venues = Venue.all
    @works = Work.all
    @delete_work = Work.order(:work_name, :language)
    render :file => 'app/views/upload/uploadfile.html.erb'
  end

  def uploadFile

    Text.all.where(work: params[:work]).delete_all

    save_file = DataFile.save(params[:upload])
    script_loaded = DataFile.parse_fd(params[:upload], params[:work], params[:character_per_line], params[:split_type])
    
    if !script_loaded
      flash[:notice] = "Script not loaded, check that file is .fdx .rtf or .txt"
      redirect_to :back
    else
      flash[:notice] = ""
      redirect_to :controller => 'cast', :action => 'index'
    end
  end


end
