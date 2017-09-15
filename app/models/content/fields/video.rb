module Content
  module Fields
    class Video < Field
      has_asset :video
      accepts_nested_attributes_for :video, allow_destroy: true

      delegate :caption, :name, to: :video
      delegate :url, :asset_content_type, to: :video

      def to_s
        video.asset
      end

      def build_associations
        build_video unless video
      end
    end
  end
end
