json.id @forum_topic_comment.id
json.comment @forum_topic_comment.comment
json.organisation @forum_topic_comment.organisation.name
json.operator @forum_topic_comment.operator.full_name
json.created_at @forum_topic_comment.created_at.strftime('%d %b %Y')