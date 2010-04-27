require 'test_helper'

class WorkordersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:workorders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create workorder" do
    assert_difference('Workorder.count') do
      post :create, :workorder => { }
    end

    assert_redirected_to workorder_path(assigns(:workorder))
  end

  test "should show workorder" do
    get :show, :id => workorders(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => workorders(:one).to_param
    assert_response :success
  end

  test "should update workorder" do
    put :update, :id => workorders(:one).to_param, :workorder => { }
    assert_redirected_to workorder_path(assigns(:workorder))
  end

  test "should destroy workorder" do
    assert_difference('Workorder.count', -1) do
      delete :destroy, :id => workorders(:one).to_param
    end

    assert_redirected_to workorders_path
  end
end
