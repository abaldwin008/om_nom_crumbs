require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@exmaple.com",
                      password: "duckpond", password_confirmation: "duckpond")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end
  
  test "name should not be to long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be to long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email vailidation for valid email addresses" do
    valid_addresses = %w[first@example.com aMY@uSer.COM ducky@pond.ri.org last.first@nc.wa duck+pond@fowl.com]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "reject invalid email addresses" do
    invalid_addresses = %w[amy@example,com user_at_duck.po user.name@example. 
                          user.name@example_ex.com duck@duck+duck.com, user@fowl..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "password should be nonblank" do
    @user.password = @user.password_confirmation = " " * 6 
    assert_not @user.valid?
  end
  
  test "password is minimum length" do
    @user.password = "a" * 5 
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
end
