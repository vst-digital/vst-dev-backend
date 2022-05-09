class ProjectUserMemosController < ApplicationController
  include ApiResponse
  before_action :set_project_user_memo, only: %i[ show update destroy ]
  before_action :current_project, only: %i[ show update destroy create index get_recieved_memo get_sent_memo]

  # GET /project_user_memos
  def index
    per_page_value = 10
    all_memos = ProjectUserMemo.get_all_sent_memos(@project, current_user)
    pagination = generate_pagination(all_memos.page(1).per(per_page_value))
    json_response(all_memos, :ok, ProjectUserMemoSerializer, pagination)
  end

  def get_sent_memo
    per_page_value = 10
    all_memos = ProjectUserMemo.get_all_sent_memos(@project, current_user)
    pagination = generate_pagination(all_memos.page(1).per(per_page_value))
    json_response(all_memos, :ok, ProjectUserMemoSerializer, pagination)
  end

  def get_recieved_memo
    per_page_value = 10
    all_memos = ProjectUserMemo.get_all_recieved_memos(@project, current_user)
    pagination = generate_pagination(all_memos.page(1).per(per_page_value))
    json_response(all_memos, :ok, ProjectUserMemoSerializer, pagination)
  end 

  # GET /project_user_memos/1
  def show
    @project_user_memo.update(read: true)
    json_response(@project_user_memo, :ok, ProjectUserMemoSerializer, pagination ={})
  end

  # POST /project_user_memos
  def create
    params["project_user_memo"]["receiver_id"].each do |receiver|
      @project_user_memo = @project.project_user_memos.new()
      @project_user_memo.body = params["project_user_memo"]["body"]["template"]
      @project_user_memo.answers = params["project_user_memo"]["answers"]
      @project_user_memo.receiver_id = receiver["id"]
      @project_user_memo.sender_id = current_user.id
      @project_user_memo.subject = params["project_user_memo"]["subject"]
      if @project_user_memo.save
        data = {}
        data["user_id"] = @project_user_memo.receiver_id
        data["message"] = json_response_return(@project_user_memo, :ok, ProjectUserMemoSerializer, pagination ={})
        MemoChannel.speak(data)
        # render json: @project_user_memo, status: :created, location: @project_user_memo
      else
        render json: @project_user_memo.errors, status: :unprocessable_entity
      end
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
      @project = current_user.projects.find_by(id: request.headers['Project'].to_i)
      if @project.blank?
        current_user.groups
        @project = Project.find_by(id: current_user.groups.map{|a| a.project.id}) 
      end
    end

    # Only allow a list of trusted parameters through.
    def project_user_memo_params
      params.require(:project_user_memo).permit(:to, :bcc, :cc, :project_id, :reply_id, :subject, :template)
    end
end