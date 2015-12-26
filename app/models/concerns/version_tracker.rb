module VersionTracker

  def creator
    first_version = self.versions.first
    user_id = nil
    user_id = first_version.whodunnit if first_version
    if user_id
      User.where(id: user_id).first
    else
      nil
    end
  end

end