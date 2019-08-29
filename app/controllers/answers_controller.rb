class AnswersController < ApplicationController

  before_action :authenticate_user!

  include Voted

  expose :answers, ->{ Answer.all }
  expose :answer, -> { params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new }
  expose :question

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    @question = answer.question
    if current_user.author_of?(answer)
      answer.update(answer_params)
    else
      redirect_to @question, alert: 'You have no rights to do this.'
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
    else
      redirect_to answer.question, alert: 'You have no rights to do this.'
    end
  end

  def best
    if current_user.author_of?(answer.question)
      answer.make_best
    else
      redirect_to answer.question, alert: 'You have no rights to do this.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body,
                                   Voted::STRONG_PARAMS,
                                   files: [],
                                   links_attributes: [:name, :url, :id, :_destroy]
                                  )
  end

end
