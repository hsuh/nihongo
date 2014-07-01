class NotesController < ApplicationController
  def index
    @notes = if params[:keywords]
               Note.where('kanji ilike ? ', "%#{params[:keywords]}%")
             else
               []
             end
  end

  def show
    @note = Note.find(params[:id])
  end
end
