require 'test_helper'

class IncidenttypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:incidenttypes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create incidenttype" do
    assert_difference('Incidenttype.count') do
      post :create, :incidenttype => { }
    end

    assert_redirected_to incidenttype_path(assigns(:incidenttype))
  end

  test "should show incidenttype" do
    get :show, :id => incidenttypes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => incidenttypes(:one).to_param
    assert_response :success
  end

  test "should update incidenttype" do
    put :update, :id => incidenttypes(:one).to_param, :incidenttype => { }
    assert_redirected_to incidenttype_path(assigns(:incidenttype))
  end

  test "should destroy incidenttype" do
    assert_difference('Incidenttype.count', -1) do
      delete :destroy, :id => incidenttypes(:one).to_param
    end

    assert_redirected_to incidenttypes_path
  end
end
