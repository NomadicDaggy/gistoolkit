 json.type "FeatureCollection"
 json.features @sectors do |sector|
  json.type "Feature"
  json.id Integer(sector["id"])
  json.properties do
    json.label (sector["label"])
  end
  json.geometry JSON.parse(sector["geometry"])
end
