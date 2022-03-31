class UserMemoTemplatesController < ApplicationController
  before_action :set_user_memo_template, only: %i[ show update destroy ]

  # GET /user_memo_templates
  def index
    @user_memo_templates = UserMemoTemplate.all

    render json: @user_memo_templates
  end

  # GET /user_memo_templates/1
  def show
    render json: @user_memo_template
  end

  # POST /user_memo_templates
  def create
    @user_memo_template = UserMemoTemplate.new(user_memo_template_params)

    if @user_memo_template.save
      render json: @user_memo_template, status: :created, location: @user_memo_template
    else
      render json: @user_memo_template.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_memo_templates/1
  def update
    if @user_memo_template.update(user_memo_template_params)
      render json: @user_memo_template
    else
      render json: @user_memo_template.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_memo_templates/1
  def destroy
    @user_memo_template.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_memo_template
      @user_memo_template = UserMemoTemplate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_memo_template_params
      params.require(:user_memo_template).permit(:memo_text)
    end
end
