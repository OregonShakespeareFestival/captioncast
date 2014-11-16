class DisplayController < ApplicationController
  def index
    #This gets returned to the view for the index.
    @atext = Text.where(visibility: true)
  end

  #Function to pull back a particular noko-obj using the ID in the database to return the element.
  def fetchline(num)
    s = Text.find(num)
    return s
  end
end
