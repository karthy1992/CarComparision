require 'test_helper'

class CrawlerControllerTest < ActionController::TestCase
  test "should get getinput" do
    get :getinput
    assert_response :success
  end

end
