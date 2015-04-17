class PreviewController < ApplicationController
  def index
  	@work = params[:work]
  	@operator = params[:operator]
  end

  def getLineSequence
  	# get the current line sequence number
    # if the current line sequence number doesn't exist
    operator_seq = Operator.find_by(:id => params[:operator]).position

  	if(operator_seq == 0)
      line_sequence_number = 1 # throw back 1
    else
      line_sequence_number = operator_seq
    end
  	# get the current work
  	work = Work.find_by(:id => params[:work])

    # use the current work to get the current line record and character name
  	line_current_record = work.texts.where(:sequence => line_sequence_number).first

    character_current = Element.find_by(:id => line_current_record.element_id)
    
    # get the previous line record and character name
    # if the line sequence isn't at 1
    if line_sequence_number != 1
  	  line_previous_record = work.texts.where(:sequence => line_sequence_number - 1).first
  	  character_previous = Element.find_by(:id => line_previous_record.element_id)
    end

    # set the content to be display initially as a string without name attached
    content = line_current_record.content_text
    # check if the name needs to be attached. if so, attach it
    if(character_current != character_previous || line_sequence_number == 1)
    		content =  character_current.name + ": " + line_current_record.content_text
    end

  	# render current line
  	render :json => { :content => content}
  end
end
