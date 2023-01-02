class CreateNoteComments < ActiveRecord::Migration[6.1]
  def change
    create_table :note_comments do |t|
      t.integer :user_id
      t.integer :note_id
      t.text :comment

      t.timestamps
    end
  end
end
