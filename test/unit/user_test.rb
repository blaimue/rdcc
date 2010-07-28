require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "find_active" do
    # only one user is set inactive
    assert_equal User.find_active.length, User.all.length - 1
  end

  test "find_by_role" do
    assert_equal User.find_by_role(PROGRAM, MANAGER), [users(:program_manager)]
    assert_equal User.find_by_role(PROGRAM, STAFF), [users(:program_staff), users(:program_manager)]
    assert_equal User.find_by_role(WORKORDER, MANAGER), [users(:workorder_manager)]
  end
  
  test "short_name" do
    assert_equal "Charlie B", users(:program_manager).short_name
  end
  
  test "full_name" do
    assert_equal "Charlie Bravo", users(:program_manager).full_name
  end
  
end
