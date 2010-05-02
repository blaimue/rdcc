require 'test_helper'

class FeedbackMailerTest < ActionMailer::TestCase
  test "new" do
    @expected.subject = 'FeedbackMailer#new'
    @expected.body    = read_fixture('new')
    @expected.date    = Time.now

    assert_equal @expected.encoded, FeedbackMailer.create_new(@expected.date).encoded
  end

end
