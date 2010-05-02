class FeedbackMailer < ActionMailer::Base
  

  def new(feedback)
    subject    'FeedbackMailer#new'
    recipients 'blaimue@gmail.com'
    from       "#{feedback.user.full_name} <#{feedback.user.email}>"
    sent_on    Time.now
    
    body       :comment => feedback.comment
  end

end
