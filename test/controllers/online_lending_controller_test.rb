require 'test_helper'

class OnlineLendingControllerTest < ActionController::TestCase
  test "should get register" do
    get :register
    assert_response :success
  end

  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get bpage" do
    get :bpage
    assert_response :success
  end

  test "should get lpage" do
    get :lpage
    assert_response :success
  end

end
