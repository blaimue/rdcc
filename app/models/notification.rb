class Notification < ActiveRecord::Base
  belongs_to :sir
  belongs_to :user
  belongs_to :teammate
end
