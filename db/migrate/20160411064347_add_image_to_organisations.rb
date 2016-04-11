class AddImageToOrganisations < ActiveRecord::Migration
  def change
    add_attachment :organisations, :image
  end
end
