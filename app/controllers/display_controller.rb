class DisplayController < ApplicationController
  def index
    #This gets returned to the view for the index.
    #@atext = Text.where(visibility: true)

    #vend all lines out to the display view
    @jtext=Text.all.to_json(:include => :element);

    #pick between multi-line view and single line with a parameter
    if params[:multi] == "1"
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
    if !defined? $currtext
      $currtext = 0
    end
    #retrieve current position
    #@current = 1+rand(18)
    #render json: @current
    render json: $currtext
  end

end
