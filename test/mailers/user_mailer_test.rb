require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'password_reset' do
    user = users(:dave)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal 'J! Scorer - Password Reset', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['robot@j-scorer.com'], mail.from
    assert_match user.reset_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end
end
