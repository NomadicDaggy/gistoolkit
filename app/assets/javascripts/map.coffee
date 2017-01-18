$ ->
	map = L.map("map").setView([56.9558, 24.0991], 13)

	osm = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
	maxZoom: 18,
  	attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
  	).addTo map

	otm = L.tileLayer('http://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
	maxZoom: 17,
	attribution: 'Map data: &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>, <a href="http://viewfinderpanoramas.org">SRTM</a> | Map style: &copy; <a href="https://opentopomap.org">OpenTopoMap</a> (<a href="https://creativecommons.org/licenses/by-sa/3.0/">CC-BY-SA</a>)'
	)

	Stamen_Watercolor = L.tileLayer('http://stamen-tiles-{s}.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.{ext}',
	attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
	minZoom: 1
	maxZoom: 16
	ext: 'png')

	opencyclemap = L.tileLayer('http://{s}.tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey={apikey}',
	maxZoom:16,
	attribution: '&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>, &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
	)

	baseMaps =
		"OpenStreetMap": osm,
		"OpenTopoMap": otm,
		"Stamen watercolor": Stamen_Watercolor,
		"No map": opencyclemap

	overlayMaps = null

	# Adds upper-right control for layer choice
	L.control.layers(baseMaps, overlayMaps).addTo map

	# Adds scale
	L.control.scale().addTo map

	# Adds drawn items' layer to map
	drawnItems = L.featureGroup().addTo map

	# Adds drawing controls
	drawControl = new (L.Control.Draw)(
	  edit: featureGroup: drawnItems
	  draw:
	    polygon: allowIntersection: false, showArea: true
	    polyline: true, imperial: false, showMeasurements: true
	    rectangle: true
	    circle: true
	    marker: true).addTo map

	# Adds drawn layer to map
	map.on 'draw:created', (e) ->
  		drawnItems.addLayer e.layer
  		return

	uploadPopup = L.popup().setContent(
		'<label for="input">Select a zipped shapefile:</label>
		<input type="file" id="file"> <br>
		<input type="submit" id="submit"> 
		<span id="warning"  style="color:red"></span>')

	L.easyButton('fa fa-upload', (btn, map) ->
			uploadPopup.setLatLng(map.getCenter()).openOn map
			return
		).addTo map

handleZipFile = (file) ->
  reader = new FileReader

  reader.onload = ->
    if reader.readyState != 2 or reader.error
      return
    else
      convertToLayer reader.result
    return

  reader.readAsArrayBuffer file
  return

convertToLayer = (buffer) ->
  shp(buffer).then (geojson) ->
    layer = L.shapefile(geojson)
    featureGroup.addLayer layer
    return
  return

document.getElementById('submit').onclick = (e) ->
  files = document.getElementById('file').files
  if files.length == 0
    return
  file = files[0]
  if file.name.slice(-3) != 'zip'
    document.getElementById('warning').innerHTML = 'Select .zip file'
    return
  else
    document.getElementById('warning').innerHTML = ''
    handleZipFile file
  return