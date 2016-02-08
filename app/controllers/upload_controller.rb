class UploadController < ApplicationController

  def index
    @venues = Venue.all
    @works = Work.all
    @delete_work = Work.order(:work_name, :language)
    render :file => 'app/views/upload/uploadfile.html.erb'
  end

  def uploadFile
    Work.find_by_id(params[:work]).update_attributes(:uploading => true, :characters_per_line => 0)
    #clear out any previous texts and operator sessions that might exist
    Text.all.where(work: params[:work]).delete_all
    Operator.delete_all(work_id: params[:work])
    # save the file to the system
    save(params[:upload])
    # get the path of the save file
    path = get_path(params[:upload])
    # queue resque task
    Resque.enqueue(
      Uploads,
      path,
      params[:work],
      params[:characters_per_line].to_i,
      params[:split_type]
    )
    redirect_to :controller => 'cast', :action => 'index'
  end

  private

  def get_path(upload)
    file_name = upload[:data].original_filename
    directory = "public/data"
    return File.join(directory, file_name)
  end

  def save(upload)
    path = get_path(upload)
    File.open(path, "wb") { |f| f.write(upload[:data].read) }
  end

end
