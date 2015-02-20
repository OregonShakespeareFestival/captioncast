class Work < ActiveRecord::Base
  # associations
  belongs_to :venue
  has_many :texts, -> { order "sequence" }
  has_many :elements

  # validations
  validates_presence_of :work_name
  validates_presence_of :venue_id
  validates_presence_of :language

  #places the name/language in the dropdown for selecting the script to edit
  def name
    "#{work_name}. #{language}"
  end
end
