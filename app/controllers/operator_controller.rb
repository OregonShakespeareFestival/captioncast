class OperatorController < ApplicationController
	def index
		#convert all lines to json and pass along in variable
		#disabled at the moment so fixture data can be used

		#set the operator variable
		@operator = params[:operator]
		@view_mode = params[:view_mode]
		@work = params[:work]
		# slurp up the required text
		@jtext = Text.all.where(work: params[:work]).to_json(:include => :element)
		# add the default position of 0 for an operator
	end

	def pushTextSeq
		operator = Operator.find_by(id: params[:operator])
		Rails.application.config.operator_positions.merge!({params[:operator] => params[:seq]})
		operator.position = params[:seq]
		operator.save

		# for debug purposes
		render :json => params[:seq]
		#when we're in production and don't need a reply
		#render :nothing => true
	end

	def select
		#TODO: refactor, break out into several methods
		@operators = Operator.all
		if request.get?
			now = DateTime.now
			@operators.each do |operator|
        # if the operator record is more than a day old remove it
				if operator.updated_at < now-1
					operator.destroy!
				end
			end
			#pull back new list of operators
			@operators = Operator.all
		end

		if request.post?
			if !params[:selected_operator].nil?
				# load exisiting operator session
				operator = Operator.find_by(id: params[:selected_operator])
				operator_name = operator.name
				view_mode = operator.view_attributes
				work = operator.work_id
				Rails.application.config.operator_positions.merge!({params[:operator] => "0"})
			else
				# Create Operator record
				operator_name = params[:operator]
				view_mode = params[:view]
				work = params[:work]
				#TODO: check to see if we will be creating a duplicate

				operator = Operator.create!(name: operator_name[:name],
					view_attributes: params[:view], work_id: params[:work], position: 0)
			end

			# set position to the value stored in the operator record
			Rails.application.config.operator_positions.merge!(
				{operator.id => operator.position})
			# redirect to index
			redirect_to :controller => 'operator', :action => 'index',
				:work => work, :view_mode => view_mode,
				:operator => operator.id
		end
	end
end
