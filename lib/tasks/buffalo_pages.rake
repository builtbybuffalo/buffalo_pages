namespace :buffalo_pages do
  task install: :environment do
    migrations = Dir["#{BuffaloPages.root}/db/migrate/*"].sort
    target_dir = "#{Rails.root}/db/migrate"

    start = DateTime.current
    target_migrations = Dir[target_dir + "/*"]

    migrations.each do |file|
      filename = file.split("/").last
      migration = filename.sub(/^[0-9]+/, "")
      start += 1.second

      target_file = "#{start.to_rails_migration_format}#{migration}"

      found = target_migrations.find { |f| f.sub(/#{migration}$/, "").length != f.length }
      if found.blank?
        FileUtils.cp(file, "#{target_dir}/#{target_file}", verbose: true)
      end
    end
  end
end
