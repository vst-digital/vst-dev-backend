class ProjectUserMemoRepliesController < ApplicationController
  include ApiResponse
  before_action :set_project_user_memo_reply, only: %i[ show update destroy ]
  before_action :current_project, only: %i[ show update destroy create index]
  before_action :set_project_user_memo, only: %i[ index create show update destroy ]
  

  # GET /project_user_memo_replies
  def index
    @project_user_memo_replies = ProjectUserMemoReply.all

    render json: @project_user_memo_replies
  end

  # GET /project_user_memo_replies/1
  def show
    render json: @project_user_memo_reply
  end

  # POST /project_user_memo_replies
  def create
    if validate_memo
      @project_user_memo_reply = @memo.project_user_memo_replies.new(project_user_memo_reply_params)
      @project_user_memo_reply.created_by = current_user
      if @project_user_memo_reply.save
        data = {}
        data["user_id"] = @project_user_memo_reply.project_user_memo.sender_id
        data["message"] = json_response(@project_user_memo_reply, :ok, ProjectUserMemoReplySerializer, pagination ={})
        MemoReplyChannel.speak(data)
        data["user_id"] = @project_user_memo_reply.project_user_memo.receiver_id
        MemoReplyChannel.speak(data)
      else
        render json: @project_user_memo_reply.errors, status: :unprocessable_entity
      end
    else
      render json: {error: "unauthorized"}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /project_user_memo_replies/1
  def update
    if @project_user_memo_reply.update(project_user_memo_reply_params)
      render json: @project_user_memo_reply
    else
      render json: @project_user_memo_reply.errors, status: :unprocessable_entity
    end
  end

  # DELETE /project_user_memo_replies/1
  def destroy
    @project_user_memo_reply.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_user_memo_reply
      @project_user_memo_reply = ProjectUserMemoReply.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_user_memo_reply_params
      params.require(:project_user_memo_reply).permit(:project_id, :content, :project_user_memo_id)
    end

    def validate_memo
      all_memos = ProjectUserMemo.get_all_memos(@project, current_user)
      all_memos.select{|a| a.id == @memo.id}.present?
    end

    def set_project_user_memo
      @memo = @project.project_user_memos.find(project_user_memo_reply_params[:project_user_memo_id])
    end

    def current_project
      @project = current_user.projects.find_by(id: request.headers['Project'].to_i)
      if @project.blank?
        current_user.groups
        @project = Project.find_by(id: current_user.groups.map{|a| a.project.id}) 
      end
    end
end