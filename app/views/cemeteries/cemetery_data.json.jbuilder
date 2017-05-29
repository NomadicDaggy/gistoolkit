# Sagatavo JSON datus kapsētas slānim
 json.type "FeatureCollection"
 json.features @cemeteries do |cemetery|
  json.type "Feature"
  json.id Integer(cemetery["id"])
  json.properties do
    json.name (cemetery["name"])
    json.address (cemetery["address"])
    json.phone_number (cemetery["phone_number"])
    json.city (cemetery["city"])
    json.region (cemetery["region"])
  end
  json.geometry JSON.parse(cemetery["geometry"])
end
