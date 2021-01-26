class MenuChoice < ApplicationRecord
  belongs_to :menu
  belongs_to :client
end
