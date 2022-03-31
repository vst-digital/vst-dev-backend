class OrganizationsController < ApplicationController
  include ApiResponse
  before_action :set_organization, only: %i[ show update destroy ]

  # GET /organizations
  def index
    per_page_value = 10
    pagination = generate_pagination(current_user.organizations.page(params[:page_no]).per(per_page_value))
    json_response(current_user.organizations, :ok, OrganizationSerializer, pagination)
  end

  # GET /organizations/1
  def show
    per_page_value = 10
    pagination = generate_pagination(current_user.organizations.page(params[:page_no]).per(per_page_value))
    json_response(current_user.organizations, :ok, OrganizationSerializer, pagination)
  end

  # POST /organizations
  def create
    if current_user.organizations.blank?
      @organization = current_user.organizations.new(organization_params)
      if @organization.save
        render json: @organization, status: :created, location: @organization
      else
        render json: @organization.errors, status: :unprocessable_entity
      end
    else
      render json: current_user.organization, status: 200
    end
  end

  # PATCH/PUT /organizations/1
  def update
    if @organization.update(organization_params)
      render json: @organization
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  # DELETE /organizations/1
  def destroy
    @organization.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def organization_params
      params.require(:organization).permit(:name, :phone, :address, :logo, :description )
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
