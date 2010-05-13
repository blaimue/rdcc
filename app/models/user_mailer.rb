class UserMailer < ActionMailer::Base
  

  def new(recipient_email, user)
    subject    '[streamline] New User'
    recipients recipient_email
    from       "info@streamline.ruthdykeman.org"
    sent_on    Time.now
    
    body       :user => user
  end
  
  def remember_token(user)
    subject    '[rdcc] Reset password'
    recipients user.email
    from       "info@streamline.ruthdykeman.org"
    sent_on    Time.now
    
    body       :reset_link => "http://streamline.ruthdykeman.org:3000/reset_password/#{user.remember_token}"
  end

end
