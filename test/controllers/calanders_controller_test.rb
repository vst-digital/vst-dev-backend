require "test_helper"

class CalandersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @calander = calanders(:one)
  end

  test "should get index" do
    get calanders_url, as: :json
    assert_response :success
  end

  test "should create calander" do
    assert_difference("Calander.count") do
      post calanders_url, params: { calander: { end_date: @calander.end_date, location: @calander.location, project_id: @calander.project_id, start_date: @calander.start_date, subject: @calander.subject, user_id: @calander.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show calander" do
    get calander_url(@calander), as: :json
    assert_response :success
  end

  test "should update calander" do
    patch calander_url(@calander), params: { calander: { end_date: @calander.end_date, location: @calander.location, project_id: @calander.project_id, start_date: @calander.start_date, subject: @calander.subject, user_id: @calander.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy calander" do
    assert_difference("Calander.count", -1) do
      delete calander_url(@calander), as: :json
    end

    assert_response :no_content
  end
end
