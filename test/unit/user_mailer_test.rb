require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "new" do
    @expected.subject = 'UserMailer#new'
    @expected.body    = read_fixture('new')
    @expected.date    = Time.now

    assert_equal @expected.encoded, UserMailer.create_new(@expected.date).encoded
  end

end
