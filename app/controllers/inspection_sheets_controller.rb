class InspectionSheetsController < ApplicationController
  before_action :set_inspection_sheet, only: %i[ show update destroy ]

  # GET /inspection_sheets
  def index
    @inspection_sheets = InspectionSheet.all

    render json: @inspection_sheets
  end

  # GET /inspection_sheets/1
  def show
    render json: @inspection_sheet
  end

  # POST /inspection_sheets
  def create
    @inspection_sheet = InspectionSheet.new(inspection_sheet_params)

    if @inspection_sheet.save
      render json: @inspection_sheet, status: :created, location: @inspection_sheet
    else
      render json: @inspection_sheet.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /inspection_sheets/1
  def update
    if @inspection_sheet.update(inspection_sheet_params)
      render json: @inspection_sheet
    else
      render json: @inspection_sheet.errors, status: :unprocessable_entity
    end
  end

  # DELETE /inspection_sheets/1
  def destroy
    @inspection_sheet.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inspection_sheet
      @inspection_sheet = InspectionSheet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def inspection_sheet_params
      params.require(:inspection_sheet).permit(:user_id)
    end
end
