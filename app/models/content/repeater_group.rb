module Content
  class RepeaterGroup < ActiveRecord::Base
    acts_as_list scope: :repeater

    belongs_to :repeater, class_name: "Content::Fields::Repeater"

    has_many :fields, as: :repeatable, class_name: "Content::Field", dependent: :destroy
    accepts_nested_attributes_for :fields, allow_destroy: true

    delegate :each, :each_with_index, :map, :any?, :first, :limit, :offset, to: :fields

    def method_missing(method_name, *args)
      field = field_from_method_name(method_name)

      return field if field.present?

      super
    end

    def respond_to_missing?(method_name, include_private = false)
      field_from_method_name(method_name).present? || super
    end

    protected

    def field_from_method_name(method_name)
      fields.find { |field| field.variable_name&.to_sym == method_name }
    end
  end
end
