module WorksHelper
  def work_details(work)
    string = "#{work.work_name}: #{work.language}"
    string += " (#{pluralize(work.texts.count, 'text')})" if not work.texts.empty?
    string
  end
end
