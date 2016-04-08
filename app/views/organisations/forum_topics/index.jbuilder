json.array! @forum_topics do |forum_topic|

  json.id forum_topic.id
  json.statement forum_topic.statement
  json.description forum_topic.description
  json.created_at forum_topic.created_at.strftime(time_format)
  json.number_of_comments forum_topic.forum_topic_comments.count

  json.operator{
    json.id forum_topic.operator.id
    json.api_token forum_topic.operator.api_token
    json.first_name forum_topic.operator.first_name
    json.phone forum_topic.operator.phone
    json.designation forum_topic.operator.designation
    json.approved_by_admin forum_topic.operator.approved_by_admin
    json.roles forum_topic.operator.roles
  }

  json.organisation{
    json.id forum_topic.organisation.id
    json.name forum_topic.organisation.name
    json.admin_verified forum_topic.organisation.admin_verified
  }

end