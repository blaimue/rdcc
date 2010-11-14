class SirMailer < ActionMailer::Base
  

  def new(sir, recipient_emails)
    subject    "[SIR] New SIR"
    recipients recipient_emails
    from       "rdcc@heroku.com"
    sent_on    Time.now
    
    body       :sir => sir
  end

end
