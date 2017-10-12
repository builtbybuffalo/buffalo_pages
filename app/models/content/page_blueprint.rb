module Content
  class PageBlueprint < ActiveRecord::Base
    has_many :field_blueprints, -> { order(position: :asc) }, dependent: :destroy
    accepts_nested_attributes_for :field_blueprints, allow_destroy: true

    has_many :pages, dependent: :destroy

    after_save :create_new_fields
    after_update :sync_field_settings

    validates :name, :template, presence: true, uniqueness: true

    protected

    def create_new_fields
      fields = []

      blueprints = field_blueprints.to_a

      # Find the ids of newly added fields
      ids = blueprints.map(&:previous_changes).reject(&:blank?).select { |x| x["id"].present? }.map { |x| x["id"].last }

      # Run through the blueprints, updating only those that were just added
      blueprints.select { |x| ids.include?(x["id"]) }.each do |blueprint|
        fields.push(fields_for_pages(blueprint.to_field))
      end

      Field.import fields.flatten, validates: false
    end

    def sync_field_settings
      field_blueprints.map(&:sync_field_settings)
    end

    private

    def fields_for_pages(field)
      fields = []

      pages.map(&:id).each do |page_id|
        cloned = field.dup
        cloned.page_id = page_id

        fields.push(cloned)
      end

      fields
    end
  end
end
