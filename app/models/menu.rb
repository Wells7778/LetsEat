class Menu < ApplicationRecord
  mount_uploader :file_location, ImageUploader

  belongs_to :category
  has_many :products, dependent: :destroy, inverse_of: :menu

  accepts_nested_attributes_for :products, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :name, :phonenumber
end
