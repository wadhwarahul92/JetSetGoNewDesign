class OrganisationDocument < ActiveRecord::Base

  belongs_to :organisation

  validates_presence_of :name, :category, :doc_type, :static_file_id

  def static_file
    @static_file ||= StaticFile.find(self.static_file_id)
  end

end