function makeMapCemeteries() {
  var geojsonLayer, Stamen_Watercolor, baseMaps, drawControl, drawnItems, map, opencyclemap, osm, otm, overlayMaps, uploadPopup, measureControl;

  map = L.map("map").setView([56.9558, 24.0991], 13);
  //Window.map =  new L.Map('map');
  //map = L.map("map").setView([56.9558, 24.0991], 13);

  osm = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxNativeZoom: 18,
  }, {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
  }).addTo(map);

  otm = L.tileLayer('http://{s}.tile.opentopomap.org/{z}/{x}/{y}.png', {
    maxNativeZoom: 17,
    attribution: 'Map data: &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>, <a href="http://viewfinderpanoramas.org">SRTM</a> | Map style: &copy; <a href="https://opentopomap.org">OpenTopoMap</a> (<a href="https://creativecommons.org/licenses/by-sa/3.0/">CC-BY-SA</a>)'
  });

  Stamen_Watercolor = L.tileLayer('http://stamen-tiles-{s}.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.{ext}', {
    attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    minZoom: 1,
    maxNativeZoom: 16,
    ext: 'png'
  });

  opencyclemap = L.tileLayer('http://{s}.tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey={apikey}', {
    maxNativeZoom: 16,
    attribution: '&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>, &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
  });

//  geojsonLayer = new L.GeoJSON.AJAX("/cemeteries.json").addTo(map);

  geojsonLayer = new L.geoJson();
  geojsonLayer.addTo(map);

  $.ajax({
    dataType: "json",
    url: "/cemeteries.json",
    success: function(data) {
      geojsonLayer.bindPopup( "<strong>" + data + "</strong><br/>" );
      geojsonLayer.addData(data);
      /*
        $(data.features).each(function(key, data) {
            geojsonLayer.bindPopup( "<strong>" + data.properties.name + "</strong><br/>" );
            geojsonLayer.addData(data);
        }); */
    }
    }).error(function() {});

  //geojsonLayer.bindPopup(feature.properties.name);

  baseMaps = {
    "OpenStreetMap": osm,
    "OpenTopoMap": otm,
    "Stamen watercolor": Stamen_Watercolor,
    "No map": opencyclemap
  };
  overlayMaps = {
    "GeoJSON": geojsonLayer
  };

  L.control.layers(baseMaps, overlayMaps).addTo(map);

  L.control.scale().addTo(map);

  measureControl = new L.Control.Measure({
    position: 'topright',
    primaryLengthUnit: 'meters',
    secondaryLengthUnit: 'kilometers',
    primaryAreaUnit: 'sqmeters',
    secondaryAreaUnit: 'hectares'
  }).addTo(map);
};

function fileControls() {
  document.getElementById('export').onclick = function(e) {
    // Extract GeoJson from featureGroup
    var data = drawnItems.toGeoJSON();

    // Stringify the GeoJson
    var convertedData = 'text/json;charset=utf-8,' + encodeURIComponent(JSON.stringify(data));

    // Find out desired filename
    var filename = prompt("Filename for exported geodata: ");

    if (filename) {
      // Create export
      document.getElementById('export').setAttribute('href', 'data:' + convertedData);
      document.getElementById('export').setAttribute('download', filename + '.geojson');
    }
  }

  var fileLayerStyle = {
    "weight":1,
    "fillColor" :'#704827',
    "color":'black',
    "fillOpacity":1
  };

  L.Control.FileLayerLoad.LABEL = '<img class="icon" src="folder.svg" alt="file icon"/>';
  L.Control.fileLayerLoad({
    fitBounds: true,
    formats: [
          '.geojson',
          '.kml',
          '.json'
      ],
    layerOptions: {
      style: fileLayerStyle,
      pointToLayer: function (data, latlng) {
        return L.circleMarker(
        latlng,
        { style: fileLayerStyle }
        );
      }
    }
  }).addTo(map);
}
