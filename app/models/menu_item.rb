class MenuItem < ActiveRecord::Base
  belongs_to :menu, touch: true
  belongs_to :menu_item, touch: true
  has_many :menu_items, -> { includes(:menu_items) }, dependent: :destroy
  accepts_nested_attributes_for :menu_items, allow_destroy: true

  acts_as_list scope: :menu

  default_scope { order(position: :asc, title: :asc) }

  serialize :meta

  def subnav?
    menu_items.any?
  end

  def meta=(m)
    self[:meta] = if m.is_a?(String)
                    YAML.load(m) rescue {}
                  else
                    m
                  end
  end

  def readable_meta
    string = YAML.dump(meta)
    string = string.sub(/^---[^\n]*\n/, "")
    string = string.sub(/^\.\.\.\n/, "")

    string
  end
end
