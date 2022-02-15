require "test_helper"

class TrashesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trash = trashes(:one)
  end

  test "should get index" do
    get trashes_url
    assert_response :success
  end

  test "should get new" do
    get new_trash_url
    assert_response :success
  end

  test "should create trash" do
    assert_difference('Trash.count') do
      post trashes_url, params: { trash: {  } }
    end

    assert_redirected_to trash_url(Trash.last)
  end

  test "should show trash" do
    get trash_url(@trash)
    assert_response :success
  end

  test "should get edit" do
    get edit_trash_url(@trash)
    assert_response :success
  end

  test "should update trash" do
    patch trash_url(@trash), params: { trash: {  } }
    assert_redirected_to trash_url(@trash)
  end

  test "should destroy trash" do
    assert_difference('Trash.count', -1) do
      delete trash_url(@trash)
    end

    assert_redirected_to trashes_url
  end
end
