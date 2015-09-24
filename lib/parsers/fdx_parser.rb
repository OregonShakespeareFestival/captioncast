# helper class for parsing fdx files

class FDXParser

  @default_text_color = "#F7E694"

  def self.parse(doc, work, characters_per_line, split_type)

    #XPath for any Nondialogue Elements
    nondialouge = doc.xpath("/FinalDraft/Content/*[not(@Type='Dialogue')]")
    #add any nondialouge elemnts to the database
    self.add_fdx_nondialouge(nondialouge, work)


    #XPath for any characters.
    characters = doc.xpath("/FinalDraft/Content/Paragraph[@Type='Character']//Text")
    #add any nondialouge elemnts to the database
    self.add_fdx_character(characters, work)

    #add the lines to the database
    self.add_fdx_lines_to_db(doc, work, characters_per_line, split_type)

  end

  def self.add_char_line(character, lineCount, charLine, visibility, work_id)
    txt = Text.create(sequence: lineCount, element: Element.find_by(element_name: character, element_type: 'CHARACTER'), work: @work, content_text: charLine, visibility: visibility)
    txt.save
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

  def self.add_element(name, type, color, work)
      e = Element.find_or_create_by!(element_name: name, element_type: type, color: color, work: work)
      e.save
  end

  def self.add_direction(e_type, lineCount, direction, visibility, work_id)
    txt = Text.create(sequence: lineCount, element: Element.find_by(element_type: e_type), work: @work, content_text: direction, visibility: visibility)
    txt.save
  end

  def self.add_fdx_lines_to_db(doc, work, characters_per_line, split_type)

    #xpath through the whole document for generaing entire script
    lines = doc.xpath("/FinalDraft/Content/Paragraph")
    lineCount = 0
    charName = ""
    last_character = ""
    character_changed = true

    #loops through the script and adds necessary lines into the database
    lines.each do |line|
      par_type = line.attributes["Type"].value.lstrip.rstrip
      #if its a character, get who and set character name
      if par_type.upcase == "CHARACTER"
        charName = line.children.children.text
        charName = charName.lstrip.rstrip.upcase

      #gets the dialogue, character should alredy be set
      elsif par_type.upcase == "DIALOGUE"
        charLine = line.children.children.text
        #send the dialogue to be split into centenses and sent to database
        lineCount = self.split_into_sentences(charName, lineCount, charLine, work, charName.length, character_changed, characters_per_line, split_type)
        #self.add_char_line(charName.upcase, lineCount, charLine, true, work)
        #lineCount += 1

      #gets parenthetical or action description (currently being ignored per request or Alayha)
      elsif par_type.upcase == "PARENTHETICAL" or par_type.upcase == "ACTION"
        #direction = line.children.children.text
        #self.add_direction(par_type.upcase, lineCount, direction, false, work)
        #lineCount += 1


      #catches all other non visible lines
      else
        direction = line.children.children.text
        self.add_direction(par_type.upcase, lineCount, direction, false, work)
        lineCount += 1
      end

      # set character changed which is used during for parsing
      if last_character == charName
        character_changed = false
        #puts "Character not changed = " + character_changed.to_s + " last, this " + last_character.to_s + " == " + charName.to_s
      else
        character_changed = true
        last_character = charName

      end

    end
  end

  def self.add_fdx_nondialouge(nondialouge, work)
      nondialouge.each do |nondialouge|
        type = nondialouge.attributes["Type"].value
        self.add_element("", type.to_str.upcase, @default_text_color, work)
    end
  end

  def self.add_fdx_character(characters, work)
    characters.each do |character|
      name = character.text.to_str.upcase.lstrip.rstrip
      self.add_element(name, "CHARACTER", @default_text_color, work)
    end
    #adds a blank line and note element for editor to use for this work
    self.add_element("", "BLANKLINE", @default_text_color, work )
    self.add_element("", "OPERATOR_NOTE", @default_text_color, work )
  end

end
