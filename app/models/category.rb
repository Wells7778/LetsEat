class Category < ApplicationRecord
  has_many :menus

  validates_presence_of :name
end
