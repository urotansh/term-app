require "test_helper"

class Admin::NoteCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get destroy" do
    get admin_note_comments_destroy_url
    assert_response :success
  end
end
