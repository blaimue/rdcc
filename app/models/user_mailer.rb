class UserMailer < ActionMailer::Base
  

  def new(recipient_email, user)
    subject    '[streamline] New User'
    recipients recipient_email
    from       "info@streamline.ruthdykeman.org"
    sent_on    Time.now
    
    body       :user => user
  end

end
