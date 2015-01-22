class OperatorController < ApplicationController
	def index
		#convert all lines to json and pass along in variable
		#disabled at the moment so fixture data can be used

		@jtext = Text.all.where(work: params[:work]).to_json(:include => :element);
	end
	def pushTextSeq
		$currtext=params[:seq]
		#testing returns line seq back as json
		render :json => $currtext
		#when we're in production and don't need a reply
		#render :nothing => true
	end
	def select

		if request.get?
			#TODO: remove old operator records when we load this page
		end

		if request.post?
			# Create Operator record
			operator_name = params[:operator]
			operator = Operator.create!(name: operator_name[:name],
				view_attributes: params[:view], work_id: params[:work])

			# redirect to index
			redirect_to :controller => 'operator', :action => 'index',
				:work => params[:work], :view_mode => params[:view],
				:operator => operator.id
		end
	end
end
