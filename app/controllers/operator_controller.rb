class OperatorController < ApplicationController
	def index
		#add logic in here that pulls and converts the active record into a json
		@jtext=Text.all.to_json;
	end
end
