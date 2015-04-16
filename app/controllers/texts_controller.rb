class TextsController < ApplicationController
  def index
    work = Work.find(params[:work_id])
    @texts = work.texts.page(params[:page]).per(100)
    @operator = params[:operator]
  end

  def edit
    @work = Work.find(params[:work_id])
    @text = @work.texts.find(params[:id])
    @previous_line = @text.previous_display_text(@work, @text.sequence)
    @current_line  = @text.display_string
    @next_line     = @text.next_display_text(@work, @text.sequence)
    @elements      = @work.elements.sort_by(&:name)
    pushTextSeq_edit(params[:seq], params[:operator])
  end

  def new
    @work = Work.find(params[:work_id])
    @text = @work.texts.find(params[:id])
    @previous_line = @text.previous_display_text(@work, @text.sequence)
    @current_line  = @text.display_string
    @next_line     = @text.next_display_text(@work, @text.sequence)
    @elements      = @work.elements.sort_by(&:name)

  end

  def show
  end

  #********************************************************************
  # inserts a line into the database. Used for splitting up a monologue
  # we get the work id, then find the _____ NOT ACTIVE______
  #******************************************************************
  def splitLine
    lne = Text.find(params[:id]) #gives us the line
    wid = lne.work_id #gives us the work id to use for selecting the right whitespace element
    seqid = lne.sequence
    txt = Text.new(
      element_id: lne.element_id,
      work_id: lne.work_id,
      content_text: lne.content_text,
      visibilit: lne.visibility
    )
    txt.insert_at(seqid + 1)
    if txt.save
      flash[:notice] = "SPLIT successfully made"
      redirect_to :back
    else
      flash[:notice] = "SPLIT NOT successfully made!!"           #need to fix this
      redirect_to :back
    end
  end

  #********************************************************************
  # removes a line from the database and lines after seqid of the line selected
  # each line after will be decremented to fil in the gap
  #******************************************************************
  def removeLine
    lne = Text.find_by_id(params[:id]) #gives us the line
    wid = lne.work_id #gives us the work id to use for selecting the right whitespace element
    seqid = lne.sequence

    #remove the current line from the database
    lne.remove_from_list
    lne.destroy

    redirect_to :controller => 'texts', :action => 'index', :work_id => wid, :page => params[:page]
  end

  #********************************************************************
  #updates the visibility of a line when the visibility is toggled in editorview
  #******************************************************************
  def toggleVis
    @text2 = Text.find(params[:id])

    #sets the visibility from false to true
    if @text2.visibility == false
      if @text2.update_attributes(:visibility => true)
          render :json => 'true'
      else
          render :json => 'Failed to update the record to true'
      end
      #sets the visibility from true to false
    else
      if @text2.update_attributes(:visibility => false)
        render :json => 'true'
      else
        render :json => 'Failed to update record to false'
      end
    end
  end

  #********************************************************************
  #updates the fields in the Text table when the editor changes the lines in a script
  #******************************************************************
  def update
    @text2 = Text.find(params[:id])

    if @text2.update_attributes(message_params)

      # Handle a successful update.
      flash[:notice] = "Text successfully updated"
      redirect_to:back
    else
      flash[:notice] = "NOTICE: ERROR DURING UPDATE"
      redirect_to:back
    end
  end



  #********************************************************************
  #updates the fields in the Text table when the editor changes the lines in a script
  #******************************************************************
  def update_from_ajax
    text_to_update = Text.find(params[:id])
    text_to_update.update_attributes(:visibility => params[:visibility], :operator_note => params[:operator_note], :content_text => params[:content_text])
    # for debug purposes
    render :json => params[:id]
  end



  #********************************************************************
  #reverts any changes made to a text
  #******************************************************************
  def revert
    text_to_revert = Text.find(params[:id])

    if text_to_revert.update_attributes(:visibility => params[:visib], :operator_note => params[:note], :content_text => params[:text])

      # Handle a successful update.
      flash[:notice] = "Text successfully reverted"
      redirect_to:back
    else
      flash[:notice] = "NOTICE: ERROR DURING REVERT"
      redirect_to:back
    end
  end

  #********************************************************************
  # adds a line with text for a specified character in the form
  # beyond the line selected to insert at
  #******************************************************************
  def addLine
    new_text = params['new_line']

    line = Text.find_by_id(params[:id]) #gives us the line we will insert after
    work_id = line.work_id #gives us the work id to use for selecting the right whitespace element
    sequence_id = line.sequence
    txt = Text.new(
      element_id: Element.find_by_id(params['character_name_dropdown']).id,
      work_id: work_id,
      content_text: new_text['content_text'],
      visibility: new_text['visibility'],
      operator_note: new_text['operator_note']
    )
    txt.insert_at(sequence_id + 1)

    if txt.save  
      flash[:notice] = "New character line successfully added"
      redirect_to:back
    else
      flash[:notice] = "New Line NOT added"        # need to fix this
       redirect_to:back
    end
  end

  
  #********************************************************************
  # Updates the editor/operator position for the preview window (used with ajax call)
  #******************************************************************
  def pushTextSeq
    operator = Operator.find_by(id: params[:operator])
    Rails.application.config.operator_positions.merge!({params[:operator] => params[:seq]})
    operator.position = params[:seq]
    operator.save

    # for debug purposes
    render :json => params[:seq]
  end


  #********************************************************************
  # Updates the editor/operator position for the preview window (used inside controller)
  #******************************************************************
  def pushTextSeq_edit(seq, operator)
    operator = Operator.find_by(id: operator)
    Rails.application.config.operator_positions.merge!({operator => seq})
    operator.position = seq
    operator.save
  end


  #********************************************************************
  # Saves the state of the text being edited, then Updates the editor/operator
  # position for the preview window (used with ajax)
  #******************************************************************
  def pushTextSeq_update
    @text2 = Text.find_by(id: params[:text_id])
    if @text2.update_attributes(:visibility => params[:visib], :operator_note => params[:note], :content_text => params[:text])
      operator = Operator.find_by(id: params[:operator])
      Rails.application.config.operator_positions.merge!({params[:operator] => params[:seq]})
      operator.position = params[:seq]
      operator.save
    end
      # for debug purposes
      render :json => params[:seq]
    
  end


  private

  #********************************************************************
  #used for bringing in params sent to the update function
  #******************************************************************
  def message_params
    params.require(:text).permit(:content_text, :visibility, :operator_note)
  end

  def vis_params
    params.require(:id).permit(:id)
  end
end
