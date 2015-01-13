class Element < ActiveRecord::Base
  belongs_to :text
  belongs_to :work
  validates_presence_of :work_id
  validates_presence_of :element_type
  validates_presence_of :color

  def element_type_enum
    ['Act Break','Scene Heading','Character','Dialogue', 'Action', 'Parenthetical', 'Operator Note', 'Non-Dialogue']
  end

  def name
    if element_name
      element_name
    else
      element_type
    end
  end
end
