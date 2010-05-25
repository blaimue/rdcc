require 'test_helper'

class SirMailerTest < ActionMailer::TestCase
  test "new" do
    @expected.subject = 'SirMailer#new'
    @expected.body    = read_fixture('new')
    @expected.date    = Time.now

    assert_equal @expected.encoded, SirMailer.create_new(@expected.date).encoded
  end

end
