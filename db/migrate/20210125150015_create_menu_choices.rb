class CreateMenuChoices < ActiveRecord::Migration[6.0]
  def change
    create_table :menu_choices do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
