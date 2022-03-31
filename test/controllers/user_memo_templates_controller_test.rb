require "test_helper"

class UserMemoTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_memo_template = user_memo_templates(:one)
  end

  test "should get index" do
    get user_memo_templates_url, as: :json
    assert_response :success
  end

  test "should create user_memo_template" do
    assert_difference("UserMemoTemplate.count") do
      post user_memo_templates_url, params: { user_memo_template: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show user_memo_template" do
    get user_memo_template_url(@user_memo_template), as: :json
    assert_response :success
  end

  test "should update user_memo_template" do
    patch user_memo_template_url(@user_memo_template), params: { user_memo_template: {  } }, as: :json
    assert_response :success
  end

  test "should destroy user_memo_template" do
    assert_difference("UserMemoTemplate.count", -1) do
      delete user_memo_template_url(@user_memo_template), as: :json
    end

    assert_response :no_content
  end
end
