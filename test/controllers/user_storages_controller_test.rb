require "test_helper"

class UserStoragesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_storage = user_storages(:one)
  end

  test "should get index" do
    get user_storages_url, as: :json
    assert_response :success
  end

  test "should create user_storage" do
    assert_difference("UserStorage.count") do
      post user_storages_url, params: { user_storage: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show user_storage" do
    get user_storage_url(@user_storage), as: :json
    assert_response :success
  end

  test "should update user_storage" do
    patch user_storage_url(@user_storage), params: { user_storage: {  } }, as: :json
    assert_response :success
  end

  test "should destroy user_storage" do
    assert_difference("UserStorage.count", -1) do
      delete user_storage_url(@user_storage), as: :json
    end

    assert_response :no_content
  end
end
