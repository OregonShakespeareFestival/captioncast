module WorksHelper
  def work_details(work)
    string = "#{work.work_name}: #{work.language}"
    string += " (#{pluralize(work.texts.length, 'text')})" if work.texts.present?
    string
  end
end
