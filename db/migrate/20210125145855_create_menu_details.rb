class CreateMenuDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :menu_items do |t|
      t.string :category
      t.string :name
      t.references :menu, null: false, foreign_key: true

      t.timestamps
    end
  end
end
