class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|

      t.integer :user_id, null: false
      t.string :session_token, null: false
      t.string :device
      t.timestamps null: false
    end
  end
end
