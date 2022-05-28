class UserStoragesController < ApplicationController
  include ApiResponse
  before_action :current_project, only: %i[ create index show update destroy ]
  before_action :set_user_storage, only: %i[ show update destroy ]

  # GET /user_storages
  def index
    json_response(@project.get_storage_parent_data(current_user) , :ok, StorageDatumSerializer, pagination ={})
  end

  def attach_file
  end

  def share_file
  
  end

  # GET /user_storages/1
  def show
    json_response(@user_storage.first.children , :ok, StorageDatumSerializer, pagination ={})
  end

  # POST /user_storages
  def create
    user_storage = @project.get_user_storage(current_user)
    if user_storage_params[:parent_id].present?
      debugger
      exsisting_record = StorageDatum.find_by(__KEY__: user_storage_params[:parent_id])
      @user_storage = exsisting_record.children.create(user_storage_params)
      @user_storage.user_storage_id = exsisting_record.user_storage_id
    else  
      @user_storage = user_storage.storage_data.new(user_storage_params)
    end
    @user_storage.project_id = @project.id
    if @user_storage.save
      debugger
      json_response(@project.get_storage_parent_data(current_user) , :ok, StorageDatumSerializer, pagination ={})
    else
      render json: @user_storage.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_storages/1
  def update
    if @user_storage.update(user_storage_params)
      render json: @user_storage
    else
      render json: @user_storage.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_storages/1
  def destroy
    @user_storage.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_storage
      @user_storage = @project.get_storage_data(current_user).select{|a| a.id == params[:id].to_i}
    end

    # Only allow a list of trusted parameters through.
    def user_storage_params
      params.require(:user_storage).require(:json).permit(:id, :name, :isDirectory, :parent_id, :size, :__KEY__)
    end

    def current_project
      @project = current_user.projects.find_by(id: request.headers['Project'].to_i)
      if @project.blank?
        current_user.groups
        @project = Project.find_by(id: current_user.groups.map{|a| a.project.id}) 
      end
    end

    # {__KEY__: 1653624258216, name: 'New Folderundefined', isDirectory: true, parent_id: '', size: 0}
    # isDirectory: true, name: "New Folderundefined"parent_id: "", size: 0, __KEY__: 1653624258216}

end
