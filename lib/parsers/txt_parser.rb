class TXTParser < BaseParser

  def parse(file)
    # add "BLANKLINE" and "OPERATOR_NOTE" elements
    Element.find_or_create_by!(element_name: "", element_type: "BLANKLINE", color: @default_text_color, work: @work_id)
    Element.find_or_create_by!(element_name: "", element_type: "OPERATOR_NOTE", color: @default_text_color, work: @work_id)

    ActiveRecord::Base.transaction do
      text_sequence = 1
      current_line_number = 1
      current_text = ""
      current_character = ""
      added_blank = false
      # iterate over each line in file
      file.each_line do |line|
        current_line_number += 1
        # split line into components
        line_components = line.split(":", 2)
        # line contains character and text
        if line_components.length == 2
          # if we know who is speaking
          if current_character != "" && added_blank == false
            # add previous character's text to database
            text_components = segment_text(current_text, current_character)
            text_components.each do |text_component|
              Text.create(sequence: text_sequence, element: Element.find_by(element_name: current_character, element_type: "CHARACTER", work: @work_id), work: @work_id, content_text: text_component, visibility: true)
              text_sequence += 1
            end
          end
          current_character = line_components[0].strip
          current_text = line_components[1].strip
          Element.find_or_create_by(element_name: current_character, element_type: "CHARACTER", color: @default_text_color, work: @work_id)
          # Reset indicator
          added_blank = false

        # line contains only text
        elsif line_components.length == 1
          
          # If we recently added a blankline and need to pick up where we left off in a characters script
          if added_blank == true && line_components[0].strip != "##"
            current_text = line_components[0].strip
            # reset blank indicator
            added_blank = false

          # if we are adding additional blank lines in a row
          elsif added_blank == true && line_components[0].strip == "##"
            Text.create(sequence: text_sequence, element: Element.find_by(element_name: "", element_type: "BLANKLINE", work: @work_id), work: @work_id, content_text: "<br/>", visibility: true)
            text_sequence += 1

          # If this is a blankline and the first time
          elsif line_components[0].strip == "##"
            # add previous character's already built text to database
            text_components = segment_text(current_text, current_character)
            text_components.each do |text_component|
              Text.create(sequence: text_sequence, element: Element.find_by(element_name: current_character, element_type: "CHARACTER", work: @work_id), work: @work_id, content_text: text_component, visibility: true)
              text_sequence += 1
            end
            # Set the indicator
            added_blank = true 

            # then add our blankline
            Text.create(sequence: text_sequence, element: Element.find_by(element_name: "", element_type: "BLANKLINE", work: @work_id), work: @work_id, content_text: "<br/>", visibility: true)
            text_sequence += 1
          else
            current_text << " " << line_components[0].strip
          end
        else
          raise current_line_number.to_s << ": " << line
        end
      end
      text_components = segment_text(current_text, current_character)
      text_components.each do |text_component|
        Text.create(sequence: text_sequence, element: Element.find_by(element_name: current_character, element_type: "CHARACTER", work: @work_id), work: @work_id, content_text: text_component, visibility: true)
        text_sequence += 1
      end
    end
  end

end
