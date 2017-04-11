module ActiveRecordAssetExtension
  extend ActiveSupport::Concern

  ASSET_DEFAULTS = { as: :attachable, class_name: "Asset", dependent: :destroy }.freeze

  class_methods do
    # Usage:
    #
    # has_asset :image
    # has_asset :pdf, order: { position: :asc }
    #
    # Procs cannot be merged together, so we have an option to order the assets
    # anything more complicated, should be done with the traditional has_many approach.
    #
    # has_one :image, -> { where(foo: :bar) }, as: :attachable, class_name: "Asset", dependent: :destroy
    def has_asset(name, options = {}) # rubocop:disable Style/PredicateName
      options.merge! ASSET_DEFAULTS

      scope = create_scope(name, options)

      reflection = ActiveRecord::Associations::Builder::HasOne.build(self, name, scope, options)
      ActiveRecord::Reflection.add_reflection(self, name, reflection)
    end

    # Usage:
    #
    # has_assets :image, order: { position: :asc }
    #
    # has_many :images, -> { where(foo: :bar).order(position: :asc) },
    #   as: :attachable, class_name: "Asset", dependent: :destroy
    def has_assets(name, options = {}, &extension) # rubocop:disable Style/PredicateName
      options.merge! ASSET_DEFAULTS

      scope = create_scope(name, options)

      reflection = ActiveRecord::Associations::Builder::HasMany.build(self, name, scope, options, &extension)
      ActiveRecord::Reflection.add_reflection(self, name, reflection)
    end

    protected

    def create_scope(name, options)
      if (order = options.delete(:order)).present?
        -> { where(attachable_scope: [name, nil]).order(order) }
      else
        -> { where(attachable_scope: [name, nil]) }
      end
    end
  end
end
