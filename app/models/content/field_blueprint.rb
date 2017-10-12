module Content
  class FieldBlueprint < ActiveRecord::Base
    acts_as_list scope: :page_blueprint

    belongs_to :page_blueprint
    has_many :fields, dependent: :destroy

    validates_associated :page_blueprint
    validates :variable_name, presence: true, uniqueness: { scope: "page_blueprint_id" }

    validates_with ::FieldBlueprintValidator
    validates_with ::RepeaterBlueprintValidator

    # Make sure the variable name can be used as a ruby variable in the templates
    def variable_name=(variable_name)
      self[:variable_name] = variable_name.downcase.gsub(/[^0-9a-z_ ]/i, "").strip.tr(" ", "_")
    end

    def config
      return {} if json_config.blank?

      @config ||= JSON.parse(json_config).with_indifferent_access
    end

    def to_field
      field_type.constantize.new(fields_for_field.merge(field_blueprint_id: id))
    end

    def sync_field_settings
      attrs = %w(position json_config variable_name field_type)

      return unless previous_changes.keys.find { |x| attrs.include?(x) }.present?

      # After the check, this value is no longer required, as on the field its `type`
      attrs.delete("field_type")

      fields.update_all(attributes.slice(*attrs).merge(type: field_type))
    end

    protected

    def fields_for_field
      attributes.except("field_type", "created_at", "updated_at", "id", "page_blueprint_id")
    end
  end
end
