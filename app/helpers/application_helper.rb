module ApplicationHelper

  def rupees(cost)
    return nil unless cost.present?
    "₹ #{number_with_delimiter(cost, delimiter: ',')}"
  end

  def time_format
    '%d %b %Y, %I:%M %p'
  end

  def object_breakup(object, html_safe = true)
    html = '<table>'
    object.attributes.each_pair do |key, value|

      parent_object = nil

      class_name = nil

      begin
        class_name = key.split('_id')[0].camelize.constantize
        parent_object = class_name.find(value)
      rescue Exception
        # do nothing
      end

      if parent_object.present?
        html += object_breakup(parent_object, false)
      else
        html += <<BEGIN
<tr>
<th>#{key}</th>
<td>#{value}</td>
</tr>
BEGIN
      end

    end
    html += '</table>'
    html_safe ? html.html_safe : html
  end

end
