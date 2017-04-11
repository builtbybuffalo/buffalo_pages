class Menu < ActiveRecord::Base
  has_many :menu_items, -> { includes(menu_items: [:menu_items]) }, dependent: :destroy
  accepts_nested_attributes_for :menu_items, allow_destroy: true

  validates :title, presence: true
end
