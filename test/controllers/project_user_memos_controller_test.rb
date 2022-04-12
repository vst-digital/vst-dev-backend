require "test_helper"

class ProjectUserMemosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_user_memo = project_user_memos(:one)
  end

  test "should get index" do
    get project_user_memos_url, as: :json
    assert_response :success
  end

  test "should create project_user_memo" do
    assert_difference("ProjectUserMemo.count") do
      post project_user_memos_url, params: { project_user_memo: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show project_user_memo" do
    get project_user_memo_url(@project_user_memo), as: :json
    assert_response :success
  end

  test "should update project_user_memo" do
    patch project_user_memo_url(@project_user_memo), params: { project_user_memo: {  } }, as: :json
    assert_response :success
  end

  test "should destroy project_user_memo" do
    assert_difference("ProjectUserMemo.count", -1) do
      delete project_user_memo_url(@project_user_memo), as: :json
    end

    assert_response :no_content
  end
end
