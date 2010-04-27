# require 'chronic'
# 
# class ActiveSupport::TimeZone
#   # requires technoweenie’s fork of the Chronic time parsing library
#   # http://github.com/technoweenie/chronic/tree/master
#   def parse(str)
#     Chronic.time_class = self
#     Chronic.parse(str, :now => now)
#   end
# end
