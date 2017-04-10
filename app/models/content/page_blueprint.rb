module Content
  class PageBlueprint < ActiveRecord::Base
    has_many :field_blueprints, -> { order(position: :asc) }, dependent: :destroy
    accepts_nested_attributes_for :field_blueprints, allow_destroy: true

    has_many :pages, dependent: :destroy

    after_save :sync_page_fields

    validates :name, :template, presence: true, uniqueness: true

    protected

    def sync_page_fields
      pages.each do |page|
        existing_fields = page.fields.map do |field|
          field.from_blueprint

          field.field_blueprint_id
        end

        # Iterate over the field blueprints and create any that are new
        field_blueprints.each do |field_blueprint|
          next if existing_fields.include? field_blueprint.id

          page.fields << field_blueprint.field_type.constantize.new.from_blueprint(field_blueprint)
        end
      end
    end
  end
end
