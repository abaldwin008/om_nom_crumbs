require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid user signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: " ",
                                         email: "email@invalid",
                                         password: "duck",
                                         password_confirmation: "pond" } }
    end
    assert_select 'form[action="/signup"]'
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
  
  test "valid user signup information" do 
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "Password",
                                         password_confirmation: "Password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
