class UserInspectionSheetsController < ApplicationController
  before_action :set_user_inspection_sheet, only: %i[ show update destroy ]

  # GET /user_inspection_sheets
  def index
    @user_inspection_sheets = UserInspectionSheet.all

    render json: @user_inspection_sheets
  end

  # GET /user_inspection_sheets/1
  def show
    render json: @user_inspection_sheet
  end

  # POST /user_inspection_sheets
  def create
    @user_inspection_sheet = UserInspectionSheet.new(user_inspection_sheet_params)

    if @user_inspection_sheet.save
      render json: @user_inspection_sheet, status: :created, location: @user_inspection_sheet
    else
      render json: @user_inspection_sheet.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_inspection_sheets/1
  def update
    if @user_inspection_sheet.update(user_inspection_sheet_params)
      render json: @user_inspection_sheet
    else
      render json: @user_inspection_sheet.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_inspection_sheets/1
  def destroy
    @user_inspection_sheet.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_inspection_sheet
      @user_inspection_sheet = UserInspectionSheet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_inspection_sheet_params
      params.fetch(:user_inspection_sheet, {})
    end
end
