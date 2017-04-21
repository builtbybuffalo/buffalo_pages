# The image asset looks for a `image_styles` method
# on the attachable class that can pass through styles hash
#
# For instance:
#
# class GalleryItem
#   has_one :image, as: :attachable, class_name: "Asset", dependent: :destroy
#   def image_styles
#     {
#       list: "401x313>",
#       banner: "1900x800#"
#     }
#   end
# end

class Asset < ActiveRecord::Base
  # Add all non-image types here, or they will be resized and / or error on upload
  FILE_TYPES = ["application/pdf"].freeze

  acts_as_list

  attr_accessor :styles

  belongs_to :attachable, polymorphic: true

  has_attached_file :asset,
    styles: lambda { |attachment|
      # If we have a file type, we need to skip or it will be resized like any image
      return {} if FILE_TYPES.include?(attachment.instance.asset_content_type)

      defaults = Rails.application.config.paperclip_defaults[:styles]
      attachable = attachment.instance.attachable

      if attachable && attachable.respond_to?(:image_styles)
        styles = attachable&.image_styles&.symbolize_keys || defaults

        styles[:thumb] = defaults[:thumb] unless styles.key?(:thumb)
        styles[:banner] = defaults[:banner] unless styles.key?(:banner)

        styles
      else
        defaults
      end
    }
  process_in_background :asset
  validates_attachment :asset,
    content_type: {

      # Add any non-image file types to FILE_TYPES above
      content_type: ["image/jpg", "image/jpeg", "image/png", "application/pdf"]
    }

  delegate :url, to: :asset

  def image?
    asset.content_type.match(/^image\//).present?
  end

  def document?
    !image?
  end
end
