class PreviewController < ApplicationController
  def index
  	@work = params[:work]
  	@operator = params[:operator]
  end

  def getLineSequence
  	# get the current line sequence number
    # if the current line sequence number doesn't exist
  	if(Rails.application.config.operator_positions[params[:operator]] == 0)
      line_sequence_number = 1 # throw back 1
    else
      line_sequence_number = Rails.application.config.operator_positions[params[:operator]] # get the current line sequence number
    end

  	# get the current work
  	work = Work.find_by(:id => params[:work])

    # use the current work to get the current line record and character name
  	line_current_record = work.texts.where(:sequence => line_sequence_number)
    character_current = Element.find_by(:id => line_current_record.pluck(:element_id)).name

    # get the previous line record and character name
    # if the line sequence isn't at 1
    if(line_sequence_number != "1")
  	  line_previous_record = work.texts.where(:sequence => line_sequence_number.to_i - 1)
  	  character_previous = Element.find_by(:id => line_previous_record.pluck(:element_id)).name
    end

    # set the content to be display initially as a string without name attached
    content = line_current_record.pluck(:content_text)[0]
    # check if the name needs to be attached. if so, attach it
    if(line_sequence_number != "1")
    	if(character_current != character_previous)
    		content =  character_current.to_s + ": " + line_current_record.pluck(:content_text)[0]
    	end
    end

  	# render current line
  	render :json => { :content => content}
  end
end
