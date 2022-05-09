require "test_helper"

class ProjectUserMemoRepliesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_user_memo_reply = project_user_memo_replies(:one)
  end

  test "should get index" do
    get project_user_memo_replies_url, as: :json
    assert_response :success
  end

  test "should create project_user_memo_reply" do
    assert_difference("ProjectUserMemoReply.count") do
      post project_user_memo_replies_url, params: { project_user_memo_reply: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show project_user_memo_reply" do
    get project_user_memo_reply_url(@project_user_memo_reply), as: :json
    assert_response :success
  end

  test "should update project_user_memo_reply" do
    patch project_user_memo_reply_url(@project_user_memo_reply), params: { project_user_memo_reply: {  } }, as: :json
    assert_response :success
  end

  test "should destroy project_user_memo_reply" do
    assert_difference("ProjectUserMemoReply.count", -1) do
      delete project_user_memo_reply_url(@project_user_memo_reply), as: :json
    end

    assert_response :no_content
  end
end
