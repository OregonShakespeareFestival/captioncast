class TextsController < ApplicationController
       

        #********************************************************************
        # inserts a line into the database. Used for splitting up a monologue
        # we get the work id, then find the 
        #******************************************************************
       def splitLine
          lne = Text.find(params[:id]) #gives us the line
          wid = lne.work_id #gives us the work id to use for selecting the right whitespace element
          seqid = lne.sequence

          #get all lines beyond seqid (sequence starts at seqid +1 and ID will be +2)
          qry = "work_id = " + wid.to_s + " AND sequence > " + seqid.to_s
          e_beyond = Text.where(qry)
          e_beyond.each do |a|

          #increment each line beyond the current one
          a.increment!(:sequence, by = 1)
          end


          #insert our new blankline element with (seqid + 1)
          txt = Text.create(sequence: (seqid + 1), element_id: Element.find_by(element_type: 'BLANKLINE').id, work_id: wid, content_text: "<br /> <br />", visibility: true)
          txt.save
          if(txt.new_record?)
            flash[:notice] = "Edit NOT successfully made"
            redirect_to:back
          else
            flash[:notice] = "Edit successfully made"
            redirect_to:back
          
          end
        end










      #********************************************************************
       #inserts a blank line into the database after seqid of the line selected
       # we get the work id, then find the 
       #******************************************************************
       def addBlank
          lne = Text.find(params[:id]) #gives us the line
          wid = lne.work_id #gives us the work id to use for selecting the right whitespace element
          seqid = lne.sequence

          #get all lines beyond seqid (sequence starts at seqid +1 and ID will be +2)
          qry = "work_id = " + wid.to_s + " AND sequence > " + seqid.to_s
          e_beyond = Text.where(qry)
          e_beyond.each do |a|

          #increment each line beyond the current one
          a.increment!(:sequence, by = 1)
          end


          #insert our new blankline element with (seqid + 1)
          txt = Text.create(sequence: (seqid + 1), element_id: Element.find_by(element_type: 'BLANKLINE').id, work_id: wid, content_text: "<br /> <br />", visibility: true)
          txt.save
          if(txt.new_record?)
            flash[:notice] = "Edit NOT successfully made"
            redirect_to:back
          else
          flash[:notice] = "Edit successfully made"
          redirect_to:back
          
          end
        end




      #********************************************************************
       # removes a line from the database and lines after seqid of the line selected
       # each line after will be decremented to fil in the gap
       #******************************************************************
       def removeLine
          puts "paramsID ==== " + params[:id]
          lne = Text.find(params[:id]) #gives us the line
          wid = lne.work_id #gives us the work id to use for selecting the right whitespace element
          seqid = lne.sequence


          #remove the current line from the database
          lne.destroy


          #get all lines beyond seqid (sequence starts at seqid +1 and ID will be +2)
          qry = "work_id = " + wid.to_s + " AND sequence > " + seqid.to_s
          e_beyond = Text.where(qry)
          e_beyond.each do |a|

          #increment each line beyond the current one
          a.decrement!(:sequence, by = 1)

          end
          redirect_to :controller => 'works', :action => 'edit', :id => 9
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
	          flash[:notice] = "Edit successfully made"
	          redirect_to:back 
          else
          	flash[:notice] = "NOTICE: ERROR DURING UPDATE"
	          redirect_to:back
          end 
       end


    private

       #********************************************************************
       #used for bringing in params sent to the update function
       #******************************************************************
	   def message_params
	      params.require(:text).permit(:content_text, :visibility)
	   end

      def vis_params
        params.require(:id).permit(:id)
     end
end
