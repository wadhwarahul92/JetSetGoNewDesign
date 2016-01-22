module AdminHelper

  def attributes_for_model(model)
    model.attributes.keys
  end

end