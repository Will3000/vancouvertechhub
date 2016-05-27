class AddImagesToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :images, :json
  end
end
