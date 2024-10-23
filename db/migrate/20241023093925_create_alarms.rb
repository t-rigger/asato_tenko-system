class CreateAlarms < ActiveRecord::Migration[7.2]
  def change
    create_table :alarms do |t|
      t.time      :time,      null: false                  # 何時に通知するか
      t.string    :title                                   # 通知タイトル(任意)
      t.boolean   :everyday,  null: false, default: false  # 毎日通知するかどうか
      t.boolean   :monday,    null: false, default: false  # 月曜に通知するかどうか
      t.boolean   :tuesday,   null: false, default: false  # 火曜に通知するかどうか
      t.boolean   :wednesday, null: false, default: false  # 水曜に通知するかどうか
      t.boolean   :thursday,  null: false, default: false  # 木曜に通知するかどうか
      t.boolean   :friday,    null: false, default: false  # 金曜に通知するかどうか
      t.boolean   :saturday,  null: false, default: false  # 土曜に通知するかどうか
      t.boolean   :sunday,    null: false, default: false  # 日曜に通知するかどうか
      t.boolean   :email,     null: false, default: false  # メールで通知するかどうか
      t.boolean   :line,      null: false, default: true   # LINEで通知するかどうか
      t.boolean   :enabled,   null: false, default: false  # この通知自体のON / OFF
      t.references :user,     null: false                  # 誰に対しての通知か

      t.timestamps
    end
  end
end
