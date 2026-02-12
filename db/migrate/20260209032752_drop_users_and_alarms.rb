class DropUsersAndAlarms < ActiveRecord::Migration[7.2]
  def up
    drop_table :alarms if table_exists?(:alarms)
    drop_table :users if table_exists?(:users)
  end

  def down
    # Recreate users table
    create_table :users do |t|
      t.string :email, default: "", null: false
      t.string :encrypted_password, default: "", null: false
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.string :provider
      t.string :uid
      t.string :name, null: false
    end
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true

    # Recreate alarms table
    create_table :alarms do |t|
      t.time :time, null: false
      t.string :title
      t.boolean :everyday, default: false, null: false
      t.boolean :monday, default: false, null: false
      t.boolean :tuesday, default: false, null: false
      t.boolean :wednesday, default: false, null: false
      t.boolean :thursday, default: false, null: false
      t.boolean :friday, default: false, null: false
      t.boolean :saturday, default: false, null: false
      t.boolean :sunday, default: false, null: false
      t.boolean :email, default: false, null: false
      t.boolean :line, default: true, null: false
      t.boolean :enabled, default: false, null: false
      t.bigint :user_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
    add_index :alarms, :user_id
  end
end
