class Menu < ApplicationRecord
  include SpreadsheetArchitect
  has_many :menu_items, dependent: :destroy
  has_many :menu_choices, dependent: :destroy
  has_many :clients, through: :menu_choices
  accepts_nested_attributes_for :menu_items

end
