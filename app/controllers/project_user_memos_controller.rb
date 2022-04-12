class ProjectUserMemosController < ApplicationController
  before_action :set_project_user_memo, only: %i[ show update destroy ]
  before_action :current_project, only: %i[ show update destroy create]

  # GET /project_user_memos
  def index
    @project_user_memos = ProjectUserMemo.all

    render json: @project_user_memos
  end

  # GET /project_user_memos/1
  def show
    render json: @project_user_memo
  end

  # POST /project_user_memos
  def create
    @project_user_memo = @project.project_user_memos.new(project_user_memo_params)

    if @project_user_memo.save
      render json: @project_user_memo, status: :created, location: @project_user_memo
    else
      render json: @project_user_memo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /project_user_memos/1
  def update
    if @project_user_memo.update(project_user_memo_params)
      render json: @project_user_memo
    else
      render json: @project_user_memo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /project_user_memos/1
  def destroy
    @project_user_memo.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_user_memo
      @project_user_memo = ProjectUserMemo.find(params[:id])
    end

    def current_project
      @project = current_user.organizations.first.projects.find(request.headers['Project'].to_i)
    end

    def 

    # Only allow a list of trusted parameters through.
    def project_user_memo_params
      params.require(:project_user_memo).permit(:from_id, :to_id, :bcc, :cc, :project_id, :reply_id, :subject)
    end
end