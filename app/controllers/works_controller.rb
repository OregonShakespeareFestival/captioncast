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
	@text = Text.find(params[:id])
end



def edit
	@lines = Text.where(:work_id => params[:id]).order(:sequence)

#, :order => 'sequence'
end


def new
	@text = Text.new
end


def editorview
	@text = Text.find(params[:id])
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
