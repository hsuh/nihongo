class NotesController < ApplicationController
  skip_before_filter :verify_authenticity_token

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

  def create
    @note = Note.new(params.require(:note).permit(:kanji, :kana, :phrase, :meaning))
    @note.save
    render 'show', status: 201
  end
end
