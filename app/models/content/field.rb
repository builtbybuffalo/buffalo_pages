module Content
  class Field < ActiveRecord::Base
    TRANSFERABLE_TYPES = ["Content::Fields::Text", "Content::Fields::TextArea", "Content::Fields::CkEditor"].freeze
    acts_as_list scope: :page

    belongs_to :thingable, polymorphic: true
    belongs_to :repeatable, polymorphic: true
    belongs_to :field_blueprint
    belongs_to :page

    validates_associated :field_blueprint, :page
    validates :variable_name, uniqueness: { scope: "page_id" }, unless: :not_required?
    validates :variable_name, presence: true, unless: :not_required?

    serialize :json_config, JSON

    # This cannot be on the field blueprint because it needs to be triggered
    # when the field is updated FROM its field blueprint and has the new data
    after_update :reconfigure, if: :json_config_changed?

    delegate :==, :to_s, :html_safe, to: :value

    def self.available_fields
      Rails.application.config.content_field_types
    end

    def self.simple_type
      name.demodulize.underscore.downcase
    end

    def config
      return {} if json_config.blank?

      self[:json_config] = JSON.parse(json_config) if json_config.is_a?(String)

      json_config.with_indifferent_access
    end

    def from_blueprint(blueprint = nil)
      update_attributes(blueprint_attributes(blueprint || field_blueprint))

      self
    end

    def build_associations; end

    # A blank method that can be overridden by subclasses to perform update actions
    def reconfigure(force = false); end

    protected

    def blueprint_attributes(blueprint)
      raise "Cannot create attributes without a valid field_blueprint object" unless blueprint.present?

      {
        field_blueprint_id: blueprint.id,
        position: blueprint.position,
        type: blueprint.field_type,
        variable_name: blueprint.variable_name,
        json_config: blueprint.json_config
      }
    end

    def not_required?
      %w(repeater seperator).include?(self.class.simple_type) || repeatable_type.present?
    end
  end
end
