class UserStoragesController < ApplicationController
  include ApiResponse
  before_action :current_project, only: %i[ create index show update destroy attach_file share_file]
  before_action :set_user_storage, only: %i[ show update destroy attach_file share_file]

  # GET /user_storages
  def index
    json_response(@project.get_storage_parent_data(current_user) , :ok, StorageDatumSerializer, pagination ={})
  end

  def attach_file
    result = convert_data_uri_to_upload({image_url: params["user_storage"]["data"], name: params["user_storage"]["name"]})
    if @user_storage.new_record?
      @user_storage.name = result[:filename]
      @user_storage.user_id = current_user.id
      @user_storage.parent_id = user_storage_params["parent_id"].to_i
      if !@user_storage.save
        render json: @user_storage.errors, status: :unprocessable_entity
      end
    end
    @user_storage.children.create(name:  result[:filename], user_id: @user_storage.user_id, project_id: @project.id).uploads.attach(io: File.open(result[:tempfile]), filename: result[:filename], content_type: result[:type])
    # @user_storage.uploads.attach(io: File.open(result[:tempfile]), filename: result[:filename], content_type: result[:type])
    json_response(@user_storage , :ok, StorageDatumSerializer, pagination ={})
  end

  def share_item
    @user_storage
  end

  def split_base64(uri_str)
    if uri_str.match(%r{^data:(.*?);(.*?),(.*)$})
      uri = Hash.new
      uri[:type] = $1 # "image/gif"
      uri[:encoder] = $2 # "base64"
      uri[:data] = $3 # data string
      uri[:extension] = $1.split('/')[1] # "gif"
      return uri
    else
      return nil
    end
  end

  def convert_data_uri_to_upload(obj_hash)
    if obj_hash[:image_url].try(:match, %r{^data:(.*?);(.*?),(.*)$})
      image_data = split_base64(obj_hash[:image_url])
      image_data_string = image_data[:data]
      image_data_binary = Base64.decode64(image_data_string)
      temp_img_file = Tempfile.new("")
      temp_img_file.binmode
      temp_img_file << image_data_binary
      temp_img_file.rewind
      return {:filename => obj_hash[:name], :type => image_data[:type], :tempfile => temp_img_file.path}
      # uploaded_file = ActionDispatch::Http::UploadedFile.new(img_params)
      # obj_hash[:image] = uploaded_file
      # obj_hash.delete(:image_url)
    end
  end

  # GET /user_storages/1
  def show
    json_response(@user_storage.children , :ok, StorageDatumSerializer, pagination ={})
  end

  # POST /user_storages
  def create
    if user_storage_params[:parent_id].present?
      exsisting_record = @project.user_storages.find_by(id: user_storage_params[:parent_id])
      @user_storage = exsisting_record.children.create(user_storage_params)
    else 
      @user_storage = @project.user_storages.new(user_storage_params)
    end
    @user_storage.user_id = current_user.id
    @user_storage.project_id = @project.id
    if @user_storage.save
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
      @user_storage = @project.user_storages.find_by(id: params[:id])
      if @user_storage.blank?
        @user_storage = @project.user_storages.new()
      end 
    end

    # Only allow a list of trusted parameters through.
    def user_storage_params
      params.require(:user_storage).permit(:id, :name, :isDirectory, :parent_id, :size, :__KEY__, :uploads)
    end

    def current_project
      @project = current_user.projects.find_by(id: request.headers['Project'].to_i)
      if @project.blank?
        current_user.groups
        @project = Project.find_by(id: current_user.groups.map{|a| a.project.id}) 
      end
    end
    
end
