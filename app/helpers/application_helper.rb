module ApplicationHelper

  def rupees(cost)
    return nil unless cost.present?
    "₹ #{number_with_delimiter(cost, delimiter: ',')}"
  end

  def time_format
    '%d %b %Y, %I:%M %p'
  end

end
