class Site < ActiveRecord::Base
  validates :name, presence: true

  has_many :site_pages
  has_many :pages, through: :site_pages

  has_many :site_countries, dependent: :destroy
  accepts_nested_attributes_for :site_countries, allow_destroy: true

  # Keep the ID of the menus on the parent and save a join
  belongs_to :main_menu, class_name: "Menu", foreign_key: :main_menu_id
  belongs_to :footer_menu, class_name: "Menu", foreign_key: :footer_menu_id
  belongs_to :legal_menu, class_name: "Menu", foreign_key: :legal_menu_id

  def locale
    self[:locale].presence || self.name.downcase
  end

  class << self
    def from_location(location)
      SiteCountry.find_by(code: location.country_code)&.site || default
    end

    def default
      where(default: true).first_or_initialize
    end
  end

  def title
    "#{self[:name]} #{'(default)' if default}"
  end

  def menu_items_for(type)
    send(type)&.menu_items || []
  end
end
