class AddAttachmentImageToAircraftImages < ActiveRecord::Migration
  def self.up
    change_table :aircraft_images do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :aircraft_images, :image
  end
end
