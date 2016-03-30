class AddAttachmentFileToStaticFiles < ActiveRecord::Migration
  def self.up
    change_table :static_files do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :static_files, :file
  end
end
