class TestsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @tests = if params[:stack_id]
               Test.where('stack_id = ?', params[:stack_id])
             else
               Test.all
             end
  end

  def edit
    test     = Test.find(params[:id])
    @question = test.testable
    @answer   = @question.answer.word
  end

  def update
    @test = Test.update_attributes!(params[:test])
    #render 'show', status: 201
  end
end
