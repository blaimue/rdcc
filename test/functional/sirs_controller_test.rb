require 'test_helper'

class SirsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sirs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sir" do
    assert_difference('Sir.count') do
      post :create, :sir => { }
    end

    assert_redirected_to sir_path(assigns(:sir))
  end

  test "should show sir" do
    get :show, :id => sirs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => sirs(:one).to_param
    assert_response :success
  end

  test "should update sir" do
    put :update, :id => sirs(:one).to_param, :sir => { }
    assert_redirected_to sir_path(assigns(:sir))
  end

  test "should destroy sir" do
    assert_difference('Sir.count', -1) do
      delete :destroy, :id => sirs(:one).to_param
    end

    assert_redirected_to sirs_path
  end
end
