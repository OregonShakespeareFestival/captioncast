# helper class for parsing rtf files

class RTFParser

  @default_text_color = "#F7E694"

  def self.parse(f, work, characters_per_line, split_type)
    rtf_dump = Yomu.read :text, f.read()
    lines = rtf_dump.split("\n")
    self.add_character_elements(lines, work)
    self.add_text_lines_to_db(lines, work, characters_per_line, split_type)
  end

  def self.add_element(name, type, color, work)
      e = Element.find_or_create_by!(element_name: name, element_type: type, color: color, work: work)
      e.save
  end

  def self.add_character_elements(arr, work)
    arr.each do |line|
      name = line.force_encoding("ISO-8859-1").encode("utf-8", replace: nil).match(/^[A-Z1-9\s\.]+(?=.?:)/)
      if (name != nil)
        #add the character "element" to the table if it does not exist
        character_name = name[0].upcase.lstrip.rstrip
        self.add_element(character_name, "CHARACTER", @default_text_color, work)
      end
    end
    #adds a blank line and note element for the editor to use for this work
    self.add_element("", "BLANKLINE", @default_text_color, work )
    self.add_element("", "OPERATOR_NOTE", @default_text_color, work )
  end

  def self.add_text_lines_to_db(arr, work, characters_per_line, split_type)
    cur_line = ""
    haveline = false
    lineCount = 1
    name = ""
    last_character = ""
    character_changed = true

    arr.each do |line|
      #look for a character name indicating the beginning of a dialogue
      a = line.force_encoding("ISO-8859-1").encode("utf-8", replace: nil).match(/^[A-Z1-9\s\.]+(?=.?:)/)
      #we have a completed monologue and need to submit it to the db
      if(a != nil and haveline == true)
        #check if this is a new character line
        if last_character == name
          character_changed = false
        else 
          character_changed = true
          last_character = name
        end
        #here we send all the data to the database if its a dialogue
        lineCount = self.split_into_sentences(name, lineCount, cur_line, work, name.length, character_changed, characters_per_line, split_type)
        haveline = false
        cur_line = ""
        name = ""
      end
      #we need to strip the name from the monologue
      if (a != nil)
        #get the character speaking
        name = a[0].upcase.lstrip.rstrip
        #returns just the line said by the character (removing excess whitespace)
        cur_line = line.force_encoding("ISO-8859-1").encode("utf-8", replace: nil).sub(/^[A-Z1-9\s\.]+.?:\s?/,"").squish
        haveline = true
      #we just append this line to our current characters script
      elsif (a == nil)
        cur_line += " " + line.force_encoding("ISO-8859-1").encode("utf-8", replace: nil).sub(/^[A-Z1-9\s\.]+.?:\s?/,"").squish
      end
    end
  end

  def self.split_into_sentences(name, lineCount, cur_line, work, character_length, character_changed, characters_per_line, split_type)
    if split_type == "S_sentences"
      sentences = self.split_by_sentence(line: cur_line, character_length: character_length, character_changed: character_changed, characters_per_line: characters_per_line)
    elsif split_type == "S_characters"
      sentences = self.split_for_max_characters_per_line(line: cur_line, character_length: character_length, character_changed: character_changed, characters_per_line: characters_per_line)
    end
    #add each sentence for this character into the database
    sentences.each do |sentence|
      self.add_char_line(name, lineCount, sentence, true, work)
      lineCount += 1
    end
    lineCount
  end

  def self.split_by_sentence(split_sentences: true, line: nil, character_length: character_length, character_changed: character_changed, characters_per_line: characters_per_line)
    results = []
    max_length = characters_per_line.to_i
    original_max_length = max_length
    line_section = Treat::Entities::Paragraph.build line
    line_section.apply :chunk, :segment

    line_section.sentences.each do |sentence|
      iteration = 1

      if split_sentences
        split_sentence = ''

        sentence.to_s.split(' ').each do |token|

          if iteration == 1 && character_changed
            max_length = max_length - (character_length - 2)
            proposed_length = split_sentence.length + token.length + character_length.to_i
          else
            proposed_length = split_sentence.length + token.length
          end

          if proposed_length > max_length
            results << split_sentence.rstrip
            split_sentence = ''
            iteration += 1
            max_length = original_max_length
          end
          split_sentence << Treat::Entities::Token.from_string(token)
          split_sentence << " "
        end
      results << split_sentence.rstrip
      iteration += 1
      else
        results << sentence.to_s.rstrip
        iteration += 1
      end
    end
    results
  end

  def self.add_char_line(character, lineCount, charLine, visibility, work)
    txt = Text.create(sequence: lineCount, element: Element.find_by(element_name: character, element_type: 'CHARACTER'), work: work, content_text: charLine, visibility: visibility)
    txt.save
  end

end
