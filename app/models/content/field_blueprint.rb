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
  end
end
