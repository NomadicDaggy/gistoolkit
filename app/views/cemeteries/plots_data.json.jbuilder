 json.type "FeatureCollection"
 json.features @plots do |plot|
  json.type "Feature"
  json.id Integer(plot["id"])
  json.properties do
    json.label (plot["label"])
  end
  json.geometry JSON.parse(plot["geometry"])
end
