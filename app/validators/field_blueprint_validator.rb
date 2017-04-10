class FieldBlueprintValidator < ActiveModel::Validator
  RESERVED = Content::Page.new.attributes.keys.freeze

  def validate(record)
    record.errors[:variable_name] << "cannot be any of the following: #{RESERVED.join(', ')}" unless valid_name?(record)
  end

  protected

  def valid_name?(record)
    !RESERVED.include? record.variable_name
  end
end
