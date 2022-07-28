class CalandersController < BaseController
  before_action :set_calander, only: %i[ show update destroy ]

  # GET /calanders
  def index
    @calander = current_user.calanders.by_project(@project)
    send_data(current_user.calanders, current_user.calanders, CalanderSerializer)
  end

  # GET /calanders/1
  def show
    json_response(@calander, :ok, CalanderSerializer, pagination={})
  end

  # POST /calanders
  def create
    @calander = current_user.calanders.by_project(@project).new(calander_params)
    @calander.shared_calander_events.each{|a| a.user_id = current_user.id}
    if @calander.save
      send_data(current_user.calanders, current_user.calanders, CalanderSerializer)
    else
      render json: @calander.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /calanders/1
  def update
    if @calander.update(calander_params)
      send_data(current_user.calanders, current_user.calanders, CalanderSerializer)
    else
      render json: @calander.errors, status: :unprocessable_entity
    end
  end

  # DELETE /calanders/1
  def destroy
    @calander.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calander
      @calander = current_user.calanders.by_project(@project).find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def calander_params
      params.require(:calander).permit(:id, :start_date, :end_date, :subject, :location, shared_calander_events_attributes: [:id, :_destroy, :calander_id, :shared_with_id])
    end
end
