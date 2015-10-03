require 'nokogiri'

class FDXParser
  include Treat::Core::DSL

  @default_text_color = "#F7E694"

  def self.parse(file, work, characters_per_line, split_type)
    doc =  Nokogiri::XML(file)
    # add non dialogue elements
    doc.xpath("/FinalDraft/Content/*[not(@Type='Dialogue')]").each do |nondialogue|
      type = nondialogue.attributes["Type"].value
      Element.find_or_create_by!(element_name: "", element_type: type.to_s.upcase, color: @default_text_color, work: work)
    end
    # add "BLANKLINE" and "OPERATOR_NOTE" elements
    Element.find_or_create_by!(element_name: "", element_type: "BLANKLINE", color: @default_text_color, work: work)
    Element.find_or_create_by!(element_name: "", element_type: "OPERATOR_NOTE", color: @default_text_color, work: work)
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
          text_components = segment_text(current_text, current_character, characters_per_line, split_type)
          text_components.each do |text_component|
            Text.create(sequence: text_sequence, element: Element.find_by(element_name: current_character, element_type: "CHARACTER"), work: work, content_text: text_component, visibility: true)
            text_sequence += 1
          end
        end
        current_character = line.text.delete("\n").squeeze(" ").strip
        Element.find_or_create_by!(element_name: current_character, element_type: "CHARACTER", color: @default_text_color, work: work)
        current_text = ""
      elsif line_type == "DIALOGUE"
        temp = ""
        line.xpath("Text").each do |text|
          temp << text
        end
        current_text << " " << temp
      else
        direction = line.text.delete("\n").squeeze(" ").strip
        Text.create(sequence: text_sequence, element: Element.find_by(element_type: line_type), work: work, content_text: direction, visibility: false)
        text_sequence += 1
      end
    end
    text_components = segment_text(current_text, current_character, characters_per_line, split_type)
    text_components.each do |text_component|
      Text.create(sequence: text_sequence, element: Element.find_by(element_name: current_character, element_type: "CHARACTER"), work: work, content_text: text_component, visibility: true)
      text_sequence += 1
    end
  end

  def self.segment_text(text, character_name, characters_per_line, split_type)
    if split_type == "S_characters"
      return segment_text_by_char_count(text, character_name, characters_per_line)
    elsif split_type == "S_sentences"
      return segment_text_by_sentences(text, character_name, characters_per_line)
    end
  end

  def self.segment_text_by_sentences(text, character_name, characters_per_line)
    results = []
    text = text.strip
    # set the initial limit using the character name
    # add a blank line if the character name is too long
    if(character_name + ": ").length > characters_per_line
      results << ""
      limit = characters_per_line
    else
      limit = characters_per_line - (character_name + ": ").length - 1
    end
    # break the text into sentences
    paragraph = Treat::Entities::Paragraph.build text
    paragraph.apply :segment
    # break the sentences that are too long by character count
    temp_text = ""
    paragraph.each do |segment|
      segment_string = segment.to_s
      if segment_string.length <= limit && temp_text == ""
        results << segment_string
      else
        segment_string = temp_text + " " + segment_string
        while limit < segment_string.length do
          if (index = segment_string.rindex(" ", limit)) != nil || (index = segment_string.index(" ", limit)) != nil
            results << segment_string[0...index]
            segment_string = segment_string[index+1..-1]
          else
            break
          end
          limit = characters_per_line
        end
        # add the remaining text
        temp_text = segment_string
      end
    end
    if temp_text != ""
      results << temp_text
    end
    return results
  end

  def self.segment_text_by_char_count(text, character_name, characters_per_line)
    results = []
    text = text.strip
    # set the initial limit using the character name
    # add a blank line if the character name is too long
    if (character_name + ": ").length > characters_per_line
      results << ""
      limit = characters_per_line
    else
      limit = characters_per_line - (character_name + ": ").length - 1
    end
    # segment the text
    while limit < text.length do
      if (index = text.rindex(" ", limit)) != nil || (index = text.index(" ", limit)) != nil
        results << text[0...index]
        text = text[index+1..-1]
      else
        break
      end
      limit = characters_per_line
    end
    # add the remaining text
    results << text
    return results
  end

end
