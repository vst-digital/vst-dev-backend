class StorageDatumController < ApplicationController
  include ApiResponse
  before_action :current_project, only: %i[ create index show update destroy attach_file share_file]
  before_action :set_storage_datum, only: %i[ show update destroy attach_file share_file]

  # GET /user_storages
  def index
    json_response(@project.get_storage_parent_data(current_user) , :ok, StorageDatumSerializer, pagination ={})
  end

  def attach_file
    result = convert_data_uri_to_upload({image_url: params["user_storage"]["data"], name: params["user_storage"]["name"]})
    @storage_datum.first.uploads.attach(io: File.open(result[:tempfile]), filename: result[:filename], content_type: result[:type])
    json_response(@storage_datum.first , :ok, StorageDatumSerializer, pagination ={})
  end

  def share_item
    @storage_datum
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
    end
  end

  # GET /user_storages/1
  def show
    json_response(@storage_datum.first.children , :ok, StorageDatumSerializer, pagination ={})
  end

  # POST /user_storages
  def create
    user_storage = @project.get_user_storage(current_user)
    if user_storage_params[:parent_id].present?
      exsisting_record = StorageDatum.find_by(__KEY__: user_storage_params[:parent_id])
      @storage_datum = exsisting_record.children.create(user_storage_params)
      @storage_datum.user_storage_id = exsisting_record.user_storage_id
    else 
      @storage_datum = user_storage.storage_data.new(user_storage_params)
    end
    @storage_datum.project_id = @project.id
    if @storage_datum.save
      json_response(@project.get_storage_parent_data(current_user) , :ok, StorageDatumSerializer, pagination ={})
    else
      render json: @storage_datum.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_storages/1
  def update
    if @storage_datum.update(user_storage_params)
      render json: @storage_datum
    else
      render json: @storage_datum.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_storages/1
  def destroy
    @storage_datum.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_storage_datum
      @storage_datum = @project.get_storage_data(current_user).select{|a| a.id == params[:id].to_i}
    end

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
