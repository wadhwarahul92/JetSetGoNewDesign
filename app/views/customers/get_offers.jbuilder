json.array! @offers do |offer|

  json.id offer.id
  json.category offer.category
  json.image offer.image.url(:small)

end