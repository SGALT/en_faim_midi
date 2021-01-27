class Menu < ApplicationRecord
  has_many :menu_items, dependent: :destroy
  has_many :menu_choices
  accepts_nested_attributes_for :menu_items
end
