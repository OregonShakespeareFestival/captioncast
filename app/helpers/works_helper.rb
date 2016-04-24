module WorksHelper
  def work_details(work)
    string = "#{work.work_name}: #{work.language}"
    string += " (#{pluralize(work.texts.length, 'text')})" if work.texts.present?
    string += " (uploading...)" if work.uploading
    string
  end
end
