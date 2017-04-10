module Content
  module Fields
    class Gallery < Field
      def value
        ::Gallery.find(self[:value]) if self[:value].present?
      end
    end
  end
end
