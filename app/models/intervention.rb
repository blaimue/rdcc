class Intervention < ActiveRecord::Base
  has_and_belongs_to_many :sirs
end
