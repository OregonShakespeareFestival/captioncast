class PreviewController < ApplicationController
  def index
  	@operator = 5
  end

  def getLineSequence
  	render :json => { :content => "this is where the current line to be displayed will go"}
  end
end
