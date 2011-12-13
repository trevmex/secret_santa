class Event < ActiveRecord::Base
  has_many :participants
end
