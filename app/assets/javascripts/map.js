// Global variables
var map, drawControl, drawnItems, layerswitcher;

function initMap() {
  var Stamen_Watercolor, baseMaps, opencyclemap, osm, otm, overlayMaps, uploadPopup, measureControl;

  map = L.map("map").setView([56.9558, 24.0991], 13);

  osm = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 18
  }, {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
  }).addTo(map);

  otm = L.tileLayer('http://{s}.tile.opentopomap.org/{z}/{x}/{y}.png', {
    maxZoom: 17,
    attribution: 'Map data: &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>, <a href="http://viewfinderpanoramas.org">SRTM</a> | Map style: &copy; <a href="https://opentopomap.org">OpenTopoMap</a> (<a href="https://creativecommons.org/licenses/by-sa/3.0/">CC-BY-SA</a>)'
  });

  Stamen_Watercolor = L.tileLayer('http://stamen-tiles-{s}.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.{ext}', {
    attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    minZoom: 1,
    maxZoom: 16,
    ext: 'png'
  });

  opencyclemap = L.tileLayer('http://{s}.tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey={apikey}', {
    maxZoom: 16,
    attribution: '&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>, &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
  });

  drawnItems = new L.FeatureGroup();
  map.addLayer(drawnItems);

  baseMaps = {
    "OpenStreetMap": osm,
    "OpenTopoMap": otm,
    "Stamen watercolor": Stamen_Watercolor,
    "No map": opencyclemap
  };
  overlayMaps = {
    "Drawn items": drawnItems
  };

  layerswitcher = L.control.layers(baseMaps, overlayMaps).addTo(map);

  L.control.scale().addTo(map);

  measureControl = new L.Control.Measure({
    position: 'topright',
    primaryLengthUnit: 'meters',
    secondaryLengthUnit: 'kilometers',
    primaryAreaUnit: 'sqmeters',
    secondaryAreaUnit: 'hectares'
  }).addTo(map);

  drawControl = new L.Control.Draw({
    edit: {
      featureGroup: drawnItems
    },
    draw: {
      polygon: {
        allowIntersection: false,
        showArea: true
      },
      polyline: true,
      circle: false,
      rectangle: false,
      imperial: false,
      showMeasurements: true,
      marker: true
    }
  }).addTo(map);

  map.on('draw:created', function(e) {
    drawnItems.addLayer(e.layer);
  });

  // Truncate value based on number of decimals
  var _round = function(num, len) {
      return Math.round(num*(Math.pow(10, len)))/(Math.pow(10, len));
  };
  // Helper method to format LatLng object (x.xxxxxx, y.yyyyyy)
  var strLatLng = function(latlng) {
      return "("+_round(latlng.lat, 6)+", "+_round(latlng.lng, 6)+")";
  };
  // Generate popup content based on layer type
  // - Returns HTML string, or null if unknown object
  var getPopupContent = function(layer) {
      // Marker - add lat/long
      if (layer instanceof L.Marker) {
          return strLatLng(layer.getLatLng());
      // Polygon - area
      } else if (layer instanceof L.Polygon) {
          var latlngs = layer._defaultShape ? layer._defaultShape() : layer.getLatLngs(),
              area = L.GeometryUtil.geodesicArea(latlngs);
          return "Area: "+L.GeometryUtil.readableArea(area, true);
      // Polyline - distance
      } else if (layer instanceof L.Polyline) {
          var latlngs = layer._defaultShape ? layer._defaultShape() : layer.getLatLngs(),
              distance = 0;
          if (latlngs.length < 2) {
              return "Distance: N/A";
          } else {
              for (var i = 0; i < latlngs.length-1; i++) {
                  distance += latlngs[i].distanceTo(latlngs[i+1]);
              }
              return "Distance: "+_round(distance, 2)+" m";
          }
      }
      return null;
  };
  // Object created - bind popup to layer, add to feature group
  map.on(L.Draw.Event.CREATED, function(event) {
      var layer = event.layer;
      var content = getPopupContent(layer);
      if (content !== null) {
          layer.bindPopup(content);
      }
      drawnItems.addLayer(layer);
  });
  // Object(s) edited - update popups
  map.on(L.Draw.Event.EDITED, function(event) {
      var layers = event.layers,
          content = null;
      layers.eachLayer(function(layer) {
          content = getPopupContent(layer);
          if (content !== null) {
              layer.setPopupContent(content);
          }
      });
  });
}

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
  var fileload = new L.Control.fileLayerLoad({
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

  fileload.loader.on('data:loaded', function (e) {
    // Add to map layer switcher
    layerswitcher.addOverlay(e.layer, e.filename);
  });
}
