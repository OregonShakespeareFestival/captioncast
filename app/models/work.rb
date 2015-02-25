class Work < ActiveRecord::Base
  belongs_to :venue
  validates_presence_of :work_name
  validates_presence_of :venue_id
  validates_presence_of :language
  has_many :texts, -> { order "sequence" }

  #places the name/language in the dropdown for selecting the script to edit
  def name
    "#{work_name}. #{language}"
  end

  def deleteScript
  	Text.delete_all(:work_id => params[:work_id])
  	Element.delete_all(:work_id => params[:work_id])
  	redirect_to:action => "index"
  end

end
