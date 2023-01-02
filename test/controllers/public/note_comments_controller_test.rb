require "test_helper"

class Public::NoteCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get public_note_comments_create_url
    assert_response :success
  end

  test "should get destroy" do
    get public_note_comments_destroy_url
    assert_response :success
  end
end
