class DisplayController < ApplicationController
  def index
    #This gets returned to the view for the index.
    #@atext = Text.where(visibility: true)

    #vend all lines out to the display view
    @jtext=Text.all.to_json;

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
    #retrieve current position
    @current = 1+rand(18)
    render json: @current
  end

end
