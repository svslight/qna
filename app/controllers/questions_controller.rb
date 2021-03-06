class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]

  include Voted

  before_action -> { question.links.build }, only: [:new, :create]

  after_action :pub_question, only: :create

  expose :questions, ->{ Question.all.order(created_at: :desc) }
  expose :question, -> { params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new }

  authorize_resource

  def create
    @question = current_user.author_questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question = Question.find(params[:id])
    authorize! :update, @question
    @question.update(question_params)
  end

  def destroy
    authorize! :destroy, question
    question.destroy
    redirect_to questions_path, notice: 'Your question was successfully deleted.'
  end

  private

  def pub_question
    return if @question.errors.any?
    ActionCable.server.broadcast "questions",
      ApplicationController.render(
                            partial: 'questions/question_simple',
                            locals: { question: @question }
      )
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     :vote,
                                     Voted::STRONG_PARAMS,
                                     files: [],
                                     links_attributes: [:name, :url, :id, :_destroy],
                                     reward_attributes: [:title, :image],
                                     )
  end

end
