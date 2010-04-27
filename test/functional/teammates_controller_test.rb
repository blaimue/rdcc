require 'test_helper'

class TeammatesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:teammates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create teammate" do
    assert_difference('Teammate.count') do
      post :create, :teammate => { }
    end

    assert_redirected_to teammate_path(assigns(:teammate))
  end

  test "should show teammate" do
    get :show, :id => teammates(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => teammates(:one).to_param
    assert_response :success
  end

  test "should update teammate" do
    put :update, :id => teammates(:one).to_param, :teammate => { }
    assert_redirected_to teammate_path(assigns(:teammate))
  end

  test "should destroy teammate" do
    assert_difference('Teammate.count', -1) do
      delete :destroy, :id => teammates(:one).to_param
    end

    assert_redirected_to teammates_path
  end
end
