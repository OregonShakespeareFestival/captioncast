class BaseParser
  include Treat::Core::DSL

  def initialize(default_text_color, work_id, characters_per_line, split_type)
    @default_text_color = default_text_color
    @work_id = work_id
    @characters_per_line = characters_per_line
    @split_type = split_type
  end

  def segment_text(text, character_name)
    if @split_type == "S_characters"
      return segment_text_by_char_count(text, character_name)
    elsif @split_type == "S_sentences"
      return segment_text_by_sentences(text, character_name)
    end
  end

  def segment_text_by_sentences(text, character_name)
    results = []
    text = text.strip
    # set the initial limit using the character name
    # add a blank line if the character name is too long
    if(character_name + ": ").length > @characters_per_line
      results << ""
      limit = @characters_per_line
    else
      limit = @characters_per_line - (character_name + ": ").length - 1
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
          limit = @characters_per_line
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

  def segment_text_by_char_count(text, character_name)
    results = []
    text = text.strip
    # set the initial limit using the character name
    # add a blank line if the character name is too long
    if (character_name + ": ").length > @characters_per_line
      results << ""
      limit = @characters_per_line
    else
      limit = @characters_per_line - (character_name + ": ").length - 1
    end
    # segment the text
    while limit < text.length do
      if (index = text.rindex(" ", limit)) != nil || (index = text.index(" ", limit)) != nil
        results << text[0...index]
        text = text[index+1..-1]
      else
        break
      end
      limit = @characters_per_line
    end
    # add the remaining text
    results << text
    return results
  end

end
