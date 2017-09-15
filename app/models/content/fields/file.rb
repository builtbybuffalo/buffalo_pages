# {
#   "content_types": ["application/zip"]
# }
module Content
  module Fields
    class File < Field
      has_asset :file
      accepts_nested_attributes_for :file, allow_destroy: true

      delegate :caption, :name, to: :file
      delegate :url, :asset_content_type, to: :file

      def to_s
        file.try(:asset)
      end

      def build_associations
        build_file unless file
      end
    end
  end
end
