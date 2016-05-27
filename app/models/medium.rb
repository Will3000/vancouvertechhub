class Medium < ActiveRecord::Base
  belongs_to :origanization
  mount_uploader :file_name, ImageUploader
end
