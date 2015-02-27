class WorksController < ApplicationController
  def index
    @works = Work.order(:work_name, :language)
  end

  def select

  end

#********************************************************************
#called by our views/works/index.html.erb to show all the scripts lines
#********************************************************************
def show
  @text = Text.find_by_id(params[:id])
end



def edit
  @lines = Text.where(:work_id => params[:id]).order(:sequence)

end


def new
  @text = Text.new
end

#deletes all texts and elements related to a script
def deleteScript
  Text.delete_all(:work_id => params[:work_id])
  Element.delete_all(:work_id => params[:work_id])
  redirect_to:action => "index"
end

def update
  @text = Text.where(:id => params[:id])
  if @text.update_attributes(message_params)
    # Handle a successful update.
    redirect_to:action => "index"
  else
    render 'edit'
  end
end


   private
   #********************************************************************
   #used for bringing in params sent to the create function
   #******************************************************************
   def message_params
      params.require(:text).permit(:content_text)
   end


end
