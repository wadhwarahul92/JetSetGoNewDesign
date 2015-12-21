module ApplicationHelper

  def rupees(cost)
    return nil unless cost.present?
    "₹ #{number_with_delimiter(cost, delimiter: ',')}"
  end

end
