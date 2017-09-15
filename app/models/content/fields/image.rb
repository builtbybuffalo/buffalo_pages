#
# Image repeater config example
# =============================
# {
#   "variable_name": "hero_image",
#   "type": "Content::Fields::Image",
#   "json_config": {
#     "styles": {
#       "large": "1000x700#",
#       "medium": "500x350#",
#       "small": "250x175#"
#     },
#     "help_text": "Upload an image to this page"
#   }
# }
#
# Normal config example
#
# Note: By default the caption and name fields will be hidden, use `show_name` and `show_caption` to show them.
# =====================
# {
#   "styles": {
#     "large": "1000x700#",
#     "medium": "500x350#",
#     "small": "250x175#"
#   },
#   "show_name": true,
#   "show_caption": true,
#   "help_text": "Upload an image to this page"
# }

module Content
  module Fields
    class Image < Field
      has_asset :image
      accepts_nested_attributes_for :image, allow_destroy: true

      delegate :caption, :name, to: :image

      def image_styles
        config[:styles]
      end

      # If the field is part of a repeater, then the after_update callback isn't
      # triggered until the dirty checking data has been reset, so use force = true instead
      def reconfigure(force = false)
        return unless json_config_changed? && !force && image&.asset.present?

        image.asset.reprocess!
      end

      def url(size = nil)
        return image.asset&.url(size) if image&.asset.present?
      end

      def to_s
        return unless image.present?

        image.asset
      end

      def build_associations
        build_image unless image
      end
    end
  end
end
