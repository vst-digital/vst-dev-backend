class ProjectsController < ApplicationController
  include ApiResponse
  before_action :set_project, only: %i[ show update destroy assign_group]
  before_action :set_group, only: %i[ assign_group ]

  # GET /projects
  def index
    per_page_value = 10
    if current_user.all_projects.present?
      pagination = generate_pagination(current_user.all_projects.page(params[:page_no]).per(per_page_value))
    else
      pagination = {}
    end
      json_response(current_user.all_projects, :ok, ProjectSerializer, pagination)
  end

  # GET /projects/1
  def show
    per_page_value = 10
    pagination = generate_pagination(current_user.all_projects.page(params[:page_no]).per(per_page_value))
    json_response(@project, :ok, ProjectSerializer, pagination)
  end

  # POST /projects
  def create
    @project = current_user.projects.new(project_params)

    if @project.save
      render json: @project, status: :created, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
  end

  def assign_group
    @project.project_groups.new(group_id: @group.id)
    if @project.save
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      if params[:project_id]
        id = params[:project_id]
      else
        id = params[:id]
      end
      @project = current_user.all_projects.find(id)
    end

    def set_group
      @group = current_user.all_groups.find(params[:group_id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:title, :project_description, :status, :group_id, :id )
    end

    def generate_pagination(paginated_obj)
      per_page_value = 10
      return {} unless paginated_obj.respond_to?(:current_page)
  
      {
        meta: {
          pagination: {
            current_page: paginated_obj.current_page,
            prev_page: paginated_obj.prev_page,
            next_page: paginated_obj.next_page,
            total_pages: paginated_obj.total_pages,
            per_page: per_page_value,
            count: paginated_obj.total_count
          }
        }
      }
    end
    
end
