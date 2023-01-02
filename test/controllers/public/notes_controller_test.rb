require "test_helper"

class Public::NotesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_notes_new_url
    assert_response :success
  end

  test "should get index" do
    get public_notes_index_url
    assert_response :success
  end

  test "should get show" do
    get public_notes_show_url
    assert_response :success
  end

  test "should get edit" do
    get public_notes_edit_url
    assert_response :success
  end
end
