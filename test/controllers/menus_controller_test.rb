require 'test_helper'

class MenusControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get menus_index_url
    assert_response :success
  end

  test "should get nex" do
    get menus_nex_url
    assert_response :success
  end

  test "should get create" do
    get menus_create_url
    assert_response :success
  end

  test "should get show" do
    get menus_show_url
    assert_response :success
  end

  test "should get edit" do
    get menus_edit_url
    assert_response :success
  end

  test "should get update" do
    get menus_update_url
    assert_response :success
  end

  test "should get destroy" do
    get menus_destroy_url
    assert_response :success
  end

end
