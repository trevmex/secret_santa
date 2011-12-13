class AddParticipantToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :participant_id, :integer
  end
end
