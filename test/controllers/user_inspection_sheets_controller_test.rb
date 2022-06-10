require "test_helper"

class UserInspectionSheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_inspection_sheet = user_inspection_sheets(:one)
  end

  test "should get index" do
    get user_inspection_sheets_url, as: :json
    assert_response :success
  end

  test "should create user_inspection_sheet" do
    assert_difference("UserInspectionSheet.count") do
      post user_inspection_sheets_url, params: { user_inspection_sheet: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show user_inspection_sheet" do
    get user_inspection_sheet_url(@user_inspection_sheet), as: :json
    assert_response :success
  end

  test "should update user_inspection_sheet" do
    patch user_inspection_sheet_url(@user_inspection_sheet), params: { user_inspection_sheet: {  } }, as: :json
    assert_response :success
  end

  test "should destroy user_inspection_sheet" do
    assert_difference("UserInspectionSheet.count", -1) do
      delete user_inspection_sheet_url(@user_inspection_sheet), as: :json
    end

    assert_response :no_content
  end
end
