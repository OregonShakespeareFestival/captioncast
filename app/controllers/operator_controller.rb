class OperatorController < ApplicationController
	def index
		#convert all lines to json and pass along in variable
		#disabled at the moment so fixture data can be used		
		@jtext=Text.all.to_json;
	end
	def pushTextSeq
		@currtext=params[:seq]
		#testing returns line seq back as json
		render :json => @currtext
		#when we're in production and don't need a reply
		#render :nothing => true
	end
end
