class DateTime
  def to_rails_migration_format
    strftime("%Y%m%d%H%M%S")
  end
end
