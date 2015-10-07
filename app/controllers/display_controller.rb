class DisplayController < ApplicationController
  def index
    @operator = params[:operator]

    #vend all lines out to the display view
    @jtext=Text.all.where(work: params[:work]).to_json(:include => :element);

    #pick between multi-line view and single line with a parameter
    if params[:view] == "multi"
      render "multi"
    elsif params[:view] == "single"
      render "index"
    end
  end

  def current
    blackout_redis_key = "operator_" << params[:operator] << "_blackout"
    sequence_redis_key = "operator_" << params[:operator] << "_sequence"
    blackout = DataCache.data.get(blackout_redis_key)
    text_sequence = DataCache.data.get(sequence_redis_key)
    render json: {:pos => text_sequence, :blackout => blackout}
  end

  def select

    if request.get?
      @operators = Operator.all
    end

    if request.post?
      operator = Operator.find_by(id: params[:selected_operator])
      view = operator.view_attributes
      work = Work.find_by(id: operator.work_id)

      redirect_to :controller => 'display', :action => 'index', :view => view,
        :work => work, :operator => operator
    end
  end

end
