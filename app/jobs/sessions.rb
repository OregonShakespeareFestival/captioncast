class Sessions < Resque::Job
  @queue = :session_managment

  def self.perform
    expiry_time = (DateTime.now.to_time - 6.hours).to_datetime
    operators = Operator.all
    operators.each do |operator|
      if operator.updated_at < expiry_time
        operator.destroy!
        Rails.application.config.operator_positions.delete(operator.id)
      end
    end
  end

end
