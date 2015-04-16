class PreviewController < ApplicationController
  def index
  	@work = params[:work]
  	@operator = params[:operator]
  end

  def getLineSequence
  	# get the current line sequence number -!!!-
  	line_sequence_number = 9
  	# get the current and previous line and character
  	work = Work.find_by(:id => params[:work])
  	line_current_record = work.texts.where(:sequence => line_sequence_number)
  	line_previous_record = work.texts.where(:sequence => line_sequence_number - 1)
  	character_current = Element.find_by(:id => line_current_record.pluck(:element_id)).name
  	character_previous = Element.find_by(:id => line_previous_record.pluck(:element_id)).name
  	# check if previous line is spoken by different character
  	if(character_current != nil && character_previous != nil && character_current != character_previous)
  		content =  character_current.to_s + ": " + line_current_record.pluck(:content_text)[0]
  	else
  		content = line_current_record.pluck(:content_text)[0]
  	end

  	# render current line
  	render :json => { :content => content}
  end
end
