class CreateMenus < ActiveRecord::Migration[8.1]
  def change
    create_table :menus, id: :uuid, default: -> { 'uuid_generate_v4()' } do |t|
      t.references :restaurant, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.text :description
      t.string :menu_type, null: false
      t.integer :status, default: 0, null: false
      t.integer :position, default: 0, null: false
      t.jsonb :metadata, default: {}, null: false

      t.timestamps
    end

    add_index :menus, :restaurant_id
    add_index :menus, :menu_type
    add_index :menus, :status
    add_index :menus, [:restaurant_id, :position]
  end
end
