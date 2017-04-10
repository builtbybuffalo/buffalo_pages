module Content
  module Fields
    class TextArea < Field
      delegate :strip, to: :value
    end
  end
end
