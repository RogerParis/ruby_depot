require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do
    roger = users(:one)
    post :create, name: roger.name, password: 'secret'
    assert_redirected_to admin_url
    assert_equal roger.id, session[:user_id]
  end

  test "should fail login" do
    roger = users(:one)
    post :create, name: roger.name, password: 'wrong'
    assert_redirected_to login_url
  end

  test "should logout" do
    delete :destroy
    assert_redirected_to store_url
  end

end
