class DisplayController < ApplicationController
  def index
    #This gets returned to the view for the index.
    #@atext = Text.where(visibility: true)

    @operator = params[:operator]

    #vend all lines out to the display view
    @jtext=Text.all.where(work: params[:work]).to_json(:include => :element);

    #pick between multi-line view and single line with a parameter
    if params[:view] == "multi"
      render "multi"
    end
  end

  #Function to pull back a particular noko-obj using the ID in the database to return the element.
  def fetchline(num)
  # s = Text.find(num)
  # return s
  end

  def poke
   # @poketext = "string"
  end

  def current
    #if !defined? $currtext
    #  $currtext = 0
    #end
    position = Rails.application.config.operator_positions[params[:operator]]
    puts "#{position} :: pow"
    #retrieve current position
    #@current = 1+rand(18)
    #render json: @current
    render json: position
  end

  def select

    if request.get?
      @operators = Operator.all
    end

    if request.post?
      operator = Operator.find_by(id: params[:selected_operator])
      view = operator.view_attributes
      work = Work.find_by(id: operator.work_id)

      redirect_to :controller => 'display', :action => 'index', :view => view,
        :work => work, :operator => operator
    end
  end

end
