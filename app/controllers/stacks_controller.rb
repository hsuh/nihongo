class StacksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @stacks = if params[:keywords]
               Stack.where('title ilike ? ', "%#{params[:keywords]}%")
             else
               Stack.all
             end
  end

  def show
    @stack = Stack.find(params[:id])
  end

  def create
    @stack = Stack.new(params.require(:stack).permit(:title))
    @stack.save
    render 'show', status: 201
  end
end
