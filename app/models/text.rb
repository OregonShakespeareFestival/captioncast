class Text < ActiveRecord::Base
  belongs_to :work
  belongs_to :element
  validates_presence_of :work_id
  validates_presence_of :element_id
  validates_presence_of :sequence
  #validates_presence_of :content_text
  #validates_presence_of :visibility

  delegate :element_name, to: :element
  delegate :element_type, to: :element

  acts_as_list column: :sequence

  def previous_display_text(work, sequence)
    previous_text = work.texts.find_by sequence: sequence - 1
    if previous_text.nil?
      "Start of Script"
    else
      previous_text.display_string
    end
  end

  def next_display_text(work_id, sequence)
    next_text = work.texts.find_by sequence: sequence + 1
    if next_text.nil?
      "End of Script"
    else
      next_text.display_string
    end
  end

  def display_string
    "#{self.element.name}: #{self.content_text unless self.element.name == "BLANKLINE"}"
  end

end
