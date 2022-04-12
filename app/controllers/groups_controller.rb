class GroupsController < ApplicationController
  include ApiResponse
  before_action :current_project, only: %i[ show update destroy members_add members_remove, index] 
  before_action :set_group, only: %i[ show update destroy members_add members_remove] 
  before_action :set_user, only: %i[ members_add members_remove ]

  # GET /groups
  def index
    per_page_value = 10
    pagination = generate_pagination(current_project.groups.page(1).per(per_page_value))
    json_response(current_project.groups, :ok, GroupSerializer, pagination)
  end

  # GET /groups/1
  def show
    json_response(@group, :ok, GroupSerializer, pagination ={})
  end

  # POST /groups
  def create
    @group = current_project.groups.new(group_params)
    if @group.save
      render json: @group, status: :created, location: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  def members_add
    @group.users << @user
    if @group.save
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end 

  def members_remove
    record_to_remove = @group.group_members.find_by(user_id: @user.id)
    if record_to_remove.destroy
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      if params[:group_id].present?
        id = params[:group_id]
      else
        id = params[:id]
      end
      @group = current_project.groups.find(id)
    end

    def set_user
      if params[:user_id].present?
        id = params[:user_id]
      else
        id = params[:id]
      end
      @user = User.find(id)
    end

    def current_project
      @project = current_user.organizations.first.projects.find(request.headers['Project'].to_i)
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:id, :name, :description, :group_id)
    end

    def members_params
      params.require(:member).permit(:id)
    end
end
