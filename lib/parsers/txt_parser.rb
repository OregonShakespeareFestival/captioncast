class TXTParser < BaseParser

  def parse(file)
    ActiveRecord::Base.transaction do
      text_sequence = 1
      current_line_number = 1
      current_text = ""
      current_character = ""
      # iterate over each line in file
      file.each_line do |line|
        current_line_number += 1
        # split line into components
        line_components = line.split(":")
        # line contains character and text
        if line_components.length == 2
          # if not the first character
          if not current_character == ""
            # add previous character's text to database
            text_components = segment_text(current_text, current_character)
            text_components.each do |text_component|
              Text.create(sequence: text_sequence, element: Element.find_by(element_name: current_character, element_type: "CHARACTER"), work: @work_id, content_text: text_component, visibility: true)
              text_sequence += 1
            end
          end
          current_character = line_components[0].strip
          current_text = line_components[1].strip
          Element.find_or_create_by(element_name: current_character, element_type: "CHARACTER", color: @default_text_color, work: @work_id)
        # line contains text
        elsif line_components.length == 1
          current_text << " " << line_components[0].strip
        else
          raise current_line_number.to_s << ": " << line
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
