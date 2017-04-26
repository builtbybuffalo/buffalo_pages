module Content
  class Page < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, use: [:slugged, :finders]

    has_many :site_pages
    has_many :sites, through: :site_pages
    accepts_nested_attributes_for :site_pages, allow_destroy: true

    belongs_to :page_blueprint
    has_many :fields, -> { where.not(type: nil).where(repeatable_type: nil).order(position: :asc) }, dependent: :destroy
    accepts_nested_attributes_for :fields, allow_destroy: true

    scope :default_includes, -> { includes(:fields, :page_blueprint) }
    scope :published, -> { default_includes.where(published: true) }

    validates :name, presence: true
    validates :slug, uniqueness: true

    after_create :import_fields_from_blueprint

    after_save :redraw_routes
    after_destroy :redraw_routes

    delegate :template, :before_action, :accepts_post, :post_action, to: :page_blueprint

    def self.redraw_routes
      ContentPageRouter.redraw
      Rails.application.reload_routes!
    end

    def redraw_routes
      self.class.redraw_routes
    end

    def title
      meta_title.present? ? meta_title : name
    end

    def url
      "/#{slug}"
    end

    def url_for(site)
      "/#{site.locale}/#{slug.gsub(/^\//, "")}"
    end

    def available_for_site?(site)
      return true if sites.empty?

      sites.include?(site)
    end

    protected

    def import_fields_from_blueprint
      page_blueprint.send :sync_page_fields
    end

    def should_generate_new_friendly_id?
      slug.blank? && name.present?
    end

    def method_missing(method_name, *args)
      field = field_from_method_name(method_name)

      return field if field.present?

      super
    end

    def respond_to_missing?(method_name, include_private = false)
      field_from_method_name(method_name).present? || super
    end

    def field_from_method_name(method_name)
      fields.find { |field| field.variable_name&.to_sym == method_name }
    end
  end
end
