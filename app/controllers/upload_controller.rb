class UploadController < ApplicationController

  before_filter :authorize

  def index
    @venues = Venue.all
    @works = Work.all
    @languages = ["English", "Spanish", "Mandarine"]
    render :file => 'app/views/upload/uploadfile.html.erb'
  end

  def uploadFile
    # create work and let program know it's uploading
    work_id = Work.create(
      :work_name => params[:work],
      :language => params[:language],
      :characters_per_line => params[:characters_per_line],
      :venue => Venue.find_by_id(params[:venue]),
      :upload_status => "Uploading"
    ).id
    # save the file to the system
    save(params[:upload])
    # get the path of the save file
    path = get_path(params[:upload])
    # queue resque task
    Resque.enqueue(
      Uploads,
      path,
      work_id,
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
