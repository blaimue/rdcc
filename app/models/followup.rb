class Followup < ActiveRecord::Base
  belongs_to :user
  belongs_to :sir
end
