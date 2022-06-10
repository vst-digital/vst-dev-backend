require "test_helper"

class InspectionSheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inspection_sheet = inspection_sheets(:one)
  end

  test "should get index" do
    get inspection_sheets_url, as: :json
    assert_response :success
  end

  test "should create inspection_sheet" do
    assert_difference("InspectionSheet.count") do
      post inspection_sheets_url, params: { inspection_sheet: { user_id: @inspection_sheet.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show inspection_sheet" do
    get inspection_sheet_url(@inspection_sheet), as: :json
    assert_response :success
  end

  test "should update inspection_sheet" do
    patch inspection_sheet_url(@inspection_sheet), params: { inspection_sheet: { user_id: @inspection_sheet.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy inspection_sheet" do
    assert_difference("InspectionSheet.count", -1) do
      delete inspection_sheet_url(@inspection_sheet), as: :json
    end

    assert_response :no_content
  end
end
