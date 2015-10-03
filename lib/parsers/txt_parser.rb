require 'treat'

class TXTParser
  include Treat::Core::DSL

  @default_text_color = "#F7E694"

  def self.parse(file, work, characters_per_line, split_type)
    text_sequence = 1
    current_text = ""
    current_character = ""
    # iterate over each line in file
    file.each_line do |line|
      # split line into components
      line_components = line.split(":")
      # line contains character and text
      if line_components.length == 2
        # if not the first character
        if not current_character == ""
          # add previous character's text to database
          text_components = segment_text(current_text, current_character, characters_per_line, split_type)
          text_components.each do |text_component|
            Text.create(sequence: text_sequence, element: Element.find_by(element_name: current_character, element_type: "CHARACTER"), work: work, content_text: text_component, visibility: true)
            text_sequence += 1
          end
        end
        current_character = line_components[0].strip
        current_text = line_components[1].strip
        Element.find_or_create_by(element_name: current_character, element_type: "CHARACTER", color: @default_text_color, work: work)
      # line contains text
      elsif line_components.length == 1
        current_text << " " << line_components[0].strip
      # line is unparsable
      else
        return false
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
