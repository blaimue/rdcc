class UserMailer < ActionMailer::Base
  

  def remember_token(user)
    subject    '[rdcc] Reset password'
    recipients user.email
    from       "rdcc@heroku.com"
    sent_on    Time.now
    
    body       :reset_link => "http://rdcc.heroku.com/reset_password/#{user.remember_token}"
  end

end
