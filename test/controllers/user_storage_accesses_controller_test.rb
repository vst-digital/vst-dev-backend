require "test_helper"

class UserStorageAccessesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_storage_access = user_storage_accesses(:one)
  end

  test "should get index" do
    get user_storage_accesses_url, as: :json
    assert_response :success
  end

  test "should create user_storage_access" do
    assert_difference("UserStorageAccess.count") do
      post user_storage_accesses_url, params: { user_storage_access: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show user_storage_access" do
    get user_storage_access_url(@user_storage_access), as: :json
    assert_response :success
  end

  test "should update user_storage_access" do
    patch user_storage_access_url(@user_storage_access), params: { user_storage_access: {  } }, as: :json
    assert_response :success
  end

  test "should destroy user_storage_access" do
    assert_difference("UserStorageAccess.count", -1) do
      delete user_storage_access_url(@user_storage_access), as: :json
    end

    assert_response :no_content
  end
end
