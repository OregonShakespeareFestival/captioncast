class WorksController < ApplicationController
  def index
    @works = Work.all
  end
  def select
  	@works = Work.all
  end
  def update
  	id = params[:id]
  	puts "work id ======== " + id
  end

end
