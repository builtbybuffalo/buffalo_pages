class Site < ActiveRecord::Base
  validates :name, presence: true

  has_many :site_pages
  has_many :pages, through: :site_pages

  has_many :site_countries, dependent: :destroy
  accepts_nested_attributes_for :site_countries, allow_destroy: true

  # Keep the ID of the menus on the parent and save a join
  belongs_to :main_menu, class_name: "Menu", foreign_key: :main_menu_id
  belongs_to :footer_menu, class_name: "Menu", foreign_key: :footer_menu_id
  belongs_to :legal_menu, class_name: "Menu", foreign_key: :legal_menu_id

  attr_accessor :locale_vars

  def locale
    self[:locale].presence || self.name.to_s.downcase
  end

  def locale_root
    "#{Rails.root}/config/locales/"
  end

  def self.default_site
    Site.find_by(default: true)
  end

  def copy_default_locales
    default = self.class.default_site
    if default.present? && default.id != id
      default.locale_paths.each do |path|
        target_path = path.sub(/#{default.locale}.yml$/, "#{locale}.yml")
        default_contents = YAML.load_file(path)
        converted_contents = {}
        converted_contents[locale] = default_contents[default.locale]
        File.open(target_path, "w") do |f|
          f.write(converted_contents.to_yaml)
          f.close
        end
      end
    end
  end

  def core_locale_path
    paths = []
    core = "#{locale_root}#{locale}.yml"
    paths.push(core) if File.exists?(core)

    paths
  end

  def full_locale_paths
    paths = core_locale_path

    if paths.present?
      paths + Dir.glob("#{locale_root}*.#{locale}.yml")
    else
      []
    end
  end

  def locale_paths
    if core_locale_path.empty? && locale.present?
      copy_default_locales
    end

    full_locale_paths
  end

  def locale_vars
    @core_locale_vars = locale_paths.map do |path|
      vars = YAML.load_file(path)

      [path.split("/").last.split(".")[0..-2].join("."), vars]
    end.to_h

    unless default?
      default = self.class.default_site
      default_vars = default.locale_vars

      @core_locale_vars = default_vars.map do |path, vars|
        lookup_path = path.sub(/#{default.locale}$/, locale)
        [lookup_path, {"#{locale}"=> recurse_locale_vars(vars[default.locale], lookup_path, [])}]
      end.to_h
    end

    @core_locale_vars
  end

  def recurse_locale_vars(vars, path, stack)
    vars.map do |key, values|
      if values.is_a?(Hash)
        [key, recurse_locale_vars(values, path, stack + [key])]
      else
        [key, @core_locale_vars.dig(*[path, locale] + stack + [key]) || values]
      end
    end.to_h
  end

  def locale_vars=(vars)
    vars.each do |file, vars|
      filepath = "#{locale_root}#{file}.yml"
      backuppath = "#{locale_root}#{file}--#{DateTime.current.utc.to_s.parameterize.underscore}.backup"
      FileUtils.cp(filepath, backuppath)
      File.open(filepath, "w") do |f|
        f.write(JSON.parse(vars.to_json).to_yaml)
        f.close
      end
    end

    I18n.backend.reload!
  end

  class << self
    def from_location(location)
      SiteCountry.find_by(code: location.country_code)&.site || default
    end

    def default
      where(default: true).first_or_initialize
    end
  end

  def title
    "#{self[:name]} #{'(default)' if default}"
  end

  def menu_items_for(type)
    send(type)&.menu_items || []
  end
end
