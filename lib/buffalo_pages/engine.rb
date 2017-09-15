module BuffaloPages
  class Engine < ::Rails::Engine
    config.autoload_paths += Dir["#{config.root}/app/**/"]
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    require "active_record_asset_extension"
    ActiveRecord::Base.send(:include, ActiveRecordAssetExtension)

    require "models/content/field"
    require "models/content/fields/text"
    require "models/content/fields/image"
    require "models/content/fields/text_area"
    require "models/content/fields/ck_editor"
    require "models/content/fields/quill"
    require "models/content/fields/gallery"
    require "models/content/fields/repeater"
    require "models/content/fields/relationship"
    require "models/content/fields/select"
    require "models/content/fields/separator"
    require "models/content/fields/file"
    require "models/content/fields/video"

    config.content_field_types = []
    config.content_field_types << Content::Fields::Text
    config.content_field_types << Content::Fields::Image
    config.content_field_types << Content::Fields::TextArea
    config.content_field_types << Content::Fields::CkEditor
    config.content_field_types << Content::Fields::Quill
    config.content_field_types << Content::Fields::Gallery
    config.content_field_types << Content::Fields::Repeater
    config.content_field_types << Content::Fields::Relationship
    config.content_field_types << Content::Fields::Select
    config.content_field_types << Content::Fields::Separator
    config.content_field_types << Content::Fields::File
    config.content_field_types << Content::Fields::Video

    config.paperclip_defaults = {
      styles: {
        thumb: "100x100>", # Used for all admin images
        small: "500x350>",
        medium: "1000x750>",
        large: "1500x850>",
        banner: "1800x700#" # Used for all header banner images
      },
      default_style: :original,
      default_url: "/media/images/missing.jpg",
      url: "/uploads/:class/:id/:style/:filename",
      path: ":rails_root/public/uploads/:class/:id/:style/:filename"
    }
  end
end
