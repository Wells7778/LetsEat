class Product < ApplicationRecord
  belongs_to :menu

  validates_presence_of :name, :price
end
