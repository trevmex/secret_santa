class Participant < ActiveRecord::Base
  has_one :gift_giver, :foreign_key => "participant_id"
  belongs_to :gift_giver, :foreign_key => "participant_id"
  belongs_to :event
end