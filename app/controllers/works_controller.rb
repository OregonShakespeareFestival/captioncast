class WorksController < ApplicationController
  

  def index
    @works = Work.all
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
	#show_id =  Work.find(params[:id])
	#puts "show ID == " + show_id.name
	puts "in edit============================================================="
	@lines = Text.where(:work_id => 3)

	
end	


def new
	@text = Text.new
end

def editorview
	puts "in editorview============" +params[:id] +" ================================================="
	@text = Text.find(params[:id])
end

def update
	puts "in update============================================================="
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
