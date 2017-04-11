class MenuItem < ActiveRecord::Base
  belongs_to :menu, touch: true
  belongs_to :menu_item, touch: true
  has_many :menu_items, -> { includes(:menu_items) }, dependent: :destroy
  accepts_nested_attributes_for :menu_items, allow_destroy: true

  acts_as_list scope: :menu

  default_scope { order(position: :asc, title: :asc) }

  def subnav?
    menu_items.any?
  end
end
