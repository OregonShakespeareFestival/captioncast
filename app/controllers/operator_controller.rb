class OperatorController < ApplicationController
	def index
		#convert all lines to json and pass along in variable
		#disabled at the moment so fixture data can be used

		#set the operator variable
		@operator = params[:operator]
		# slurp up the required text
		@jtext = Text.all.where(work: params[:work]).to_json(:include => :element)
		# add the default position of 0 for an operator
		Rails.application.config.operator_positions.merge!({params[:operator] => "0"})
	end
	def pushTextSeq
		#$currtext=params[:seq]
		#testing returns line seq back as json
		Rails.application.config.operator_positions.merge!({params[:operator] => params[:seq]})

		#is this still necessary??
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
