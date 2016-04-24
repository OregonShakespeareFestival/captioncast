class TextsController < ApplicationController
  def index
    work = Work.find(params[:work_id])
    @texts = work.texts.page(params[:page]).per(100)
    @sequence = params[:lineSequence]
  end

  def new
    @work = Work.find(params[:work_id])
    @text = @work.texts.find(params[:id])
    @previous_line = @text.previous_display_text(@work, @text.sequence)
    @current_line  = @text.display_string
    @next_line     = @text.next_display_text(@work, @text.sequence)
    @elements      = @work.elements.sort_by(&:name)
  end

  def create
    new_text = params['new_line']
    line = Text.find_by_id(params[:id]) #gives us the line we will insert after
    work_id = line.work_id #gives us the work id to use for selecting the right whitespace element
    sequence = line.sequence
    txt = Text.new(
      element_id: Element.find_by_id(params['character_name_dropdown']).id,
      work_id: work_id,
      content_text: new_text['content_text'],
      visibility: new_text['visibility'],
      operator_note: new_text['operator_note']
    )
    txt.insert_at(sequence + 1)
    if txt.save
      flash[:notice] = "New character line successfully added"
      redirect_to :controller => 'texts', :action => 'index', :work_id => work_id, :page => params[:page], :lineSequence => sequence + 1
    else
      flash[:notice] = "New Line NOT added"        # need to fix this
       redirect_to :controller => 'texts', :action => 'index', :work_id => work_id, :page => params[:page], :lineSequence => sequence + 1
    end
  end

  def edit
    @work = Work.find(params[:work_id])
    @text = @work.texts.find(params[:id])
    @previous_line = @text.previous_display_text(@work, @text.sequence)
    @current_line  = @text.display_string
    @next_line     = @text.next_display_text(@work, @text.sequence)
    @elements      = @work.elements.sort_by(&:name)
  end

  def update
    @text2 = Text.find(params[:id])
    message_params = params.require(:text).permit(:content_text, :visibility, :operator_note)
    if @text2.update_attributes(message_params)
      # Handle a successful update.
      flash[:notice] = "Text successfully updated"
      redirect_to :controller => 'texts', :action => 'index', :work_id => @text2.work_id.to_s, :page => params[:page], :lineSequence => params[:sequence]
    else
      flash[:notice] = "NOTICE: ERROR DURING UPDATE"
      redirect_to :controller => 'texts', :action => 'index', :work_id => @text2.work_id.to_s, :page => params[:page], :lineSequence => params[:sequence]
    end
  end

  def destroy
    lne = Text.find_by_id(params[:id]) #gives us the line
    wid = lne.work_id #gives us the work id to use for selecting the right whitespace element
    seqid = lne.sequence

    #remove the current line from the database
    lne.remove_from_list
    lne.destroy

    redirect_to :controller => 'texts', :action => 'index', :work_id => wid, :page => params[:page], :lineSequence => seqid
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

end
