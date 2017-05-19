 json.type "FeatureCollection"
 json.features @streets do |street|
  json.type "Feature"
  json.id Integer(street["id"])
  json.properties do
    json.kind (street["kind"])
  end
  json.geometry JSON.parse(street["geometry"])
end
