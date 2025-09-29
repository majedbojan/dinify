class CreateRestaurantUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :restaurant_users, id: :uuid, default: -> { 'uuid_generate_v4()' } do |t|
      t.references :restaurant, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :bigint
      t.string :role, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :restaurant_users, [ :restaurant_id, :user_id ], unique: true
    add_index :restaurant_users, :role
    add_index :restaurant_users, :status
  end
end
