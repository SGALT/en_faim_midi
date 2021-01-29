class AddPositionToMenuItems < ActiveRecord::Migration[6.0]
  def change
    add_column :menu_items, :position, :integer
  end
end
