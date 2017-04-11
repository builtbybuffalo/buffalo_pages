class SitePage < ActiveRecord::Base
  belongs_to :site
  belongs_to :page, class_name: "Content::Page"
end
