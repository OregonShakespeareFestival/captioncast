class OperatorController < ApplicationController
	def index
		#convert all lines to json and pass along in variable
		#disabled at the moment so fixture data can be used		
		@jtext=Texts.all.to_json;
	end
end
