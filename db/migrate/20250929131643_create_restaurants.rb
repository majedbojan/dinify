class CreateRestaurants < ActiveRecord::Migration[8.1]
  def change
    create_table :restaurants, id: :uuid, default: -> { 'uuid_generate_v4()' } do |t|
      t.string :name, null: false
      t.text :description
      t.string :phone
      t.string :email
      t.text :address
      t.string :website
      t.integer :status, default: 0, null: false
      t.jsonb :metadata, default: {}, null: false

      t.timestamps
    end

    add_index :restaurants, :name
    add_index :restaurants, :email
    add_index :restaurants, :status
  end
end
