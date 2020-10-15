class CreateBadges < ActiveRecord::Migration[6.0]
  def change
    create_table :badges do |t|
      t.string :title
      t.belongs_to :question, foreign_key: true, null: false
      t.belongs_to :user, default: nil, foreign_key: true

      t.timestamps
    end
  end
end
