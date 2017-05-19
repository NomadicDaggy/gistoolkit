 json.type "FeatureCollection"
 json.features @points do |point|
  json.type "Feature"
  json.id Integer(point["id"])
  json.properties do
    json.diameter (point["diameter"])
    json.kind (point["kind"])
    json.label (point["label"])
  end
  json.geometry JSON.parse(point["geometry"])
end
