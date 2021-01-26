class Client < ApplicationRecord
  belongs_to :user
  has_many :menu_choices
  validates :name, presence: true
  validates :formule, presence: true
  validates :specificity, presence: true
end
