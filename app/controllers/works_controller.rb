class WorksController < ApplicationController

  before_filter :authorize

  def index
    @works = Work.order(:work_name, :language)
  end

  def edit
    @work = Work.find_by_id(params[:id])
  end

  def destroy
    Operator.delete_all(:work_id => params[:id])
    Text.delete_all(:work_id => params[:id])
    Element.delete_all(:work_id => params[:id])
    Work.find_by_id(params[:id]).delete
    redirect_to :controller => 'cast', :action => 'index'
  end

  def update
    @work = Work.find_by_id(params[:id])
    @work.update(params.require(:work).permit(:work_name))
    redirect_to :controller => 'cast', :action => 'index'
  end

  private

  # used for bringing in params sent to the create function
  def message_params
    params.require(:text).permit(:content_text)
  end

end
