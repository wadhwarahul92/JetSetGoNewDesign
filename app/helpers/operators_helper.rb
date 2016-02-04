module OperatorsHelper

  def operators_for_collection
    Operator.verified.collect{ |c| ["#{c.full_name} - #{c.email}", c.id] }
  end

end
