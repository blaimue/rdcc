require 'test_helper'

class InterventionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:interventions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create intervention" do
    assert_difference('Intervention.count') do
      post :create, :intervention => { }
    end

    assert_redirected_to intervention_path(assigns(:intervention))
  end

  test "should show intervention" do
    get :show, :id => interventions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => interventions(:one).to_param
    assert_response :success
  end

  test "should update intervention" do
    put :update, :id => interventions(:one).to_param, :intervention => { }
    assert_redirected_to intervention_path(assigns(:intervention))
  end

  test "should destroy intervention" do
    assert_difference('Intervention.count', -1) do
      delete :destroy, :id => interventions(:one).to_param
    end

    assert_redirected_to interventions_path
  end
end
