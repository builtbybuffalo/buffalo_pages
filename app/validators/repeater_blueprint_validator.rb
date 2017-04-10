class RepeaterBlueprintValidator < ActiveModel::Validator
  def validate(record)
    return unless repeater?(record)

    unless repeater_config_present?(record)
      record.errors[:json_config] << "must contain an array of repeater definitions"
    end

    record.errors[:json_config] << "cannot have duplicate variable names" unless repeater_variables_names_valid?(record)
  end

  protected

  def repeater_config_present?(record)
    record.config[:repeaters].present?
  end

  def repeater_variables_names_valid?(record)
    return unless repeater_config_present?(record)

    variable_names = record.config[:repeaters].collect { |rep| rep[:variable_name] }

    !variable_names.detect { |var| variable_names.count(var) > 1 }
  end

  def repeater?(record)
    record.field_type == "Content::Fields::Repeater"
  end
end
