require 'nokogiri'

class FDXParser < BaseParser

  def parse(file)
    ActiveRecord::Base.transaction do
      doc =  Nokogiri::XML(file)
      # add non dialogue elements
      doc.xpath("/FinalDraft/Content/*[not(@Type='Dialogue')]").each do |nondialogue|
        type = nondialogue.attributes["Type"].value
        Element.find_or_create_by!(element_name: "", element_type: type.to_s.upcase, color: @default_text_color, work: @work_id)
      end
      # add "BLANKLINE" and "OPERATOR_NOTE" elements
      Element.find_or_create_by!(element_name: "", element_type: "BLANKLINE", color: @default_text_color, work: @work_id)
      Element.find_or_create_by!(element_name: "", element_type: "OPERATOR_NOTE", color: @default_text_color, work: @work_id)
      # add paragraphs
      text_sequence = 1
      current_text = ""
      current_character = ""
      # iterate over each paragraph
      doc.xpath("/FinalDraft/Content/Paragraph").each do |line|
        line_type = line.attributes["Type"].value.strip.upcase
        if line_type == "CHARACTER"
          # if not the first character
          if not current_character == ""
            # add previous character's text to database
            text_components = segment_text(current_text, current_character)
            text_components.each do |text_component|
              Text.create(sequence: text_sequence, element: Element.find_by(element_name: current_character, element_type: "CHARACTER"), work: @work_id, content_text: text_component, visibility: true)
              text_sequence += 1
            end
          end
          current_character = line.text.delete("\n").squeeze(" ").strip
          Element.find_or_create_by!(element_name: current_character, element_type: "CHARACTER", color: @default_text_color, work: @work_id)
          current_text = ""
        elsif line_type == "DIALOGUE"
          temp = ""
          line.xpath("Text").each do |text|
            temp << text
          end
          current_text << " " << temp
        else
          direction = line.text.delete("\n").squeeze(" ").strip
          Text.create(sequence: text_sequence, element: Element.find_by(element_type: line_type), work: @work_id, content_text: direction, visibility: false)
          text_sequence += 1
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
