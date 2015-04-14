class WorksController < ApplicationController
  def index
    @works = Work.order(:work_name, :language)
  end

def select
    @operators = Operator.all
    if request.get?
      now = DateTime.now
      @operators.each do |operator|
        # if the operator record is more than a day old remove it
        if operator.updated_at < now-1
          operator.destroy!
        end
      end
      #pull back new list of operators
      @operators = Operator.all
    end

    if request.post?
      if !params[:selected_operator].nil?
        # load exisiting operator session
        operator = Operator.find_by(id: params[:selected_operator])
        operator_name = operator.name
        view_mode = operator.view_attributes
        work = operator.work_id
        Rails.application.config.operator_positions.merge!({params[:operator] => "0"})
      else
        # Create Operator record
        operator_name = params[:operator]
        view_mode = params[:view]
        work = params[:work]
        puts "$$$$ " + operator_name[:name] + " " + work
        operator = Operator.create!(name: operator_name[:name],
          view_attributes: params[:view], work_id: work, position: 0)
      end

      # set position to the value stored in the operator record
      Rails.application.config.operator_positions.merge!(
        {operator.id => operator.position})
      redirect_to :controller => 'texts', :action => 'index',
        work_id: params[:work], :view_mode => view_mode,
        :operator => operator.id
    end
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

#**********************************************************
#deletes all texts and elements related to a script
#***********************************************************
def deleteScript
  Text.delete_all(:work_id => params[:work_id])
  Element.delete_all(:work_id => params[:work_id])
  redirect_to :controller => 'upload', :action => 'index'
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
