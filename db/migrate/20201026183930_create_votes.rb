class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.belongs_to :voteable, polymorphic: true
      t.belongs_to :user, default: nil, foreign_key: true
      t.integer :score, default: 1

      t.timestamps
    end
  end
end
