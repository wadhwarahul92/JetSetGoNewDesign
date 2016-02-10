module OrganisationsHelper

  def organisations_for_collection
    Organisation.all.collect{ |c| [c.name, c.id] }
  end

end