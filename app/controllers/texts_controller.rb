class TextsController < ApplicationController
       

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
	      params.require(:text).permit(:content_text)
	   end
end
