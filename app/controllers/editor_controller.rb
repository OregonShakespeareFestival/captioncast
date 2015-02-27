class EditorController < ApplicationController
  def index
    @editor = Text.all.where(work: params[:work])
  end
end
