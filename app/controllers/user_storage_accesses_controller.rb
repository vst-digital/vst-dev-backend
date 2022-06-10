class UserStorageAccessesController < ApplicationController
  include ApiResponse
  before_action :current_project, only: %i[ create index show update destroy attach_file share_file]
  before_action :set_user_storage_access, only: %i[ show update destroy ]

  # GET /user_storage_accesses
  def index
    @user_storage_accesses = current_user.user_storage_accesses.by_project(@project)
    render json: @user_storage_accesses
  end

  # GET /user_storage_accesses/1
  def show
    render json: @user_storage_access
  end

  # POST /user_storage_accesses
  def create
    @user_storage_access = current_user.user_storage_accesses.by_project(@project).new(user_storage_access_params)
    if @user_storage_access.save
      render json: @user_storage_access, status: :created, location: @user_storage_access
    else
      render json: @user_storage_access.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_storage_accesses/1
  def update
    if @user_storage_access.update(user_storage_access_params)
      render json: @user_storage_access
    else
      render json: @user_storage_access.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_storage_accesses/1
  def destroy
    @user_storage_access.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_storage_access
      @user_storage_access = @project.user_storage_accesses.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_storage_access_params
      params.require(:user_storage_access).permit(:id, :user_storage_id, :shared_by_id, :shared_with_id )
    end
    
    def current_project
      @project = current_user.projects.find_by(id: request.headers['Project'].to_i)
      if @project.blank?
        current_user.groups
        @project = Project.find_by(id: current_user.groups.map{|a| a.project.id}) 
      end
    end

end
