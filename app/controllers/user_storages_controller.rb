class UserStoragesController < ApplicationController
  include ApiResponse
  before_action :current_project, only: %i[ create index show update destroy attach_file]
  before_action :set_user_storage, only: %i[ show update destroy attach_file]

  # GET /user_storages
  def index
    json_response(@project.get_storage_parent_data(current_user) , :ok, StorageDatumSerializer, pagination ={})
  end

  def attach_file
    # @user_storage.first.update(user_storage_params)
    result = convert_data_uri_to_upload({image_url: params["user_storage"]["data"], name: params["user_storage"]["name"]})
    @user_storage.uploads.attach(io: File.open(result[:tempfile]), filename: result[:filename], content_type: result[:type])
    json_response(@user_storage , :ok, StorageDatumSerializer, pagination ={})
  end

  def share_file
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
    json_response(@user_storage.first.children , :ok, StorageDatumSerializer, pagination ={})
  end

  # POST /user_storages
  def create
    user_storage = @project.get_user_storage(current_user)
    if user_storage_params[:parent_id].present?
      exsisting_record = StorageDatum.find_by(__KEY__: user_storage_params[:parent_id])
      @user_storage = exsisting_record.children.create(user_storage_params)
      @user_storage.user_storage_id = exsisting_record.user_storage_id
    else 
      @user_storage = user_storage.storage_data.new(user_storage_params)
    end
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
      # @user_storage = @project.get_storage_data(current_user).select{|a| a.id == params[:id].to_i}
      @user_storage = @project.get_storage_data(current_user).first
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
