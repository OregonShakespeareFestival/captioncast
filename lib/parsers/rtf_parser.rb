require 'yomu'

class RTFParser < BaseParser

  def parse(file)
    # add "BLANKLINE" and "OPERATOR_NOTE" elements
    Element.find_or_create_by!(element_name: "", element_type: "BLANKLINE", color: @default_text_color, work: @work_id)
    Element.find_or_create_by!(element_name: "", element_type: "OPERATOR_NOTE", color: @default_text_color, work: @work_id)
    ActiveRecord::Base.transaction do
      text_sequence = 1
      current_text = ""
      current_character = ""
      # iterate over each line in file
      rtf_dump = Yomu.read :text, file
      lines = rtf_dump.split("\n")
      lines.each do |line|
        # line contains character
        if line.index(":") != nil
          # if not the first character
          if not current_character == ""
            # add previous character's text to database
            text_components = segment_text(current_text, current_character)
            text_components.each do |text_component|
              Text.create(sequence: text_sequence, element: Element.find_by(element_name: current_character, element_type: "CHARACTER"), work: @work_id, content_text: text_component, visibility: true)
              text_sequence += 1
            end
          end
          current_character = line.delete(":").strip
          current_text = ""
          Element.find_or_create_by(element_name: current_character, element_type: "CHARACTER", color: @default_text_color, work: @work_id)
        # line contains text
        else
          current_text << " " << line.strip
        end
      end
      text_components = segment_text(current_text, current_character)
      text_components.each do |text_component|
        Text.create(sequence: text_sequence, element: Element.find_by(element_name: current_character, element_type: "CHARACTER"), work: @work_id, content_text: text_component, visibility: true)
        text_sequence += 1
      end
    end
  end

end
