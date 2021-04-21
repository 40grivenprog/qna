class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.integer :user_id, foreign_key: true
      t.integer :question_id, foreign_key: true

      t.timestamps
    end
  end
end
