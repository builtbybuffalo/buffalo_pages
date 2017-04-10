module Content
  module Fields
    class Quill < Field
      has_assets :images

      before_save :build_images

      # Image uploads will look for this
      def image_styles
        nil
      end

      protected

      def build_images
        return if images.present?

        images.build
      end
    end
  end
end
