class DisplayController < ApplicationController

  def index

    @atext = Text.where(visibility: true)

    position = 8
    t = fetchline(position)

    if t.visibility.to_s == "true"
      @currentcaption = t.content_text
    else
      @currentcaption = "nontext"
    end

  end

  def fetchline(num)
    s = Text.find(num)
    return s
  end

end
