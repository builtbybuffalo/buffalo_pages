class SiteCountry < ActiveRecord::Base
  belongs_to :site
  validates :code, uniqueness: true
end
