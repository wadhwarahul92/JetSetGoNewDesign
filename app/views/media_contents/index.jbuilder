json.array! @media_contents do |media_content|

  json.id media_content.id
  json.one_liner media_content.one_liner
  json.description media_content.description
  json.image_url media_content.image_url
  json.redirect_url media_content.redirect_url

end