class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :name
      t.string :email
      t.boolean :one_only
      t.references :event

      t.timestamps
    end
    add_index :participants, :event_id
  end
end
