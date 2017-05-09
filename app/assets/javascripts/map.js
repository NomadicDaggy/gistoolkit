function makeMap() {
  var Stamen_Watercolor, baseMaps, drawControl, drawnItems, map, opencyclemap, osm, otm, overlayMaps, uploadPopup, measureControl;

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
  L.control.layers(baseMaps, overlayMaps).addTo(map);

  L.control.scale().addTo(map);

  measureControl = new L.Control.Measure({
    position: 'topright',
    primaryLengthUnit: 'meters',
    secondaryLengthUnit: 'kilometers',
    primaryAreaUnit: 'sqmeters',
    secondaryAreaUnit: 'hectares'
  }).addTo(map);

//var geojsonLayer = new L.GeoJSON.AJAX("/cemeteries.json").addTo(map);
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

  /*
    uploadPopup = L.popup().setContent('<label for="input">Select a zipped shapefile:</label> <input type="file" id="file"> <br> <input type="submit" id="submit"> <span id="warning"  style="color:red"></span>');

    return L.easyButton('fa fa-upload', function(btn, map) {
      uploadPopup.setLatLng(map.getCenter()).openOn(map);
    }).addTo(map);
  */

  document.getElementById('export').onclick = function(e) {
    // Extract GeoJson from featureGroup
    var data = drawnItems.toGeoJSON();

    // Stringify the GeoJson
    var convertedData = 'text/json;charset=utf-8,' + encodeURIComponent(JSON.stringify(data));

    var filename = prompt("Filename for exported geodata: ");

    // Create export
    document.getElementById('export').setAttribute('href', 'data:' + convertedData);
    document.getElementById('export').setAttribute('download', filename + '.geojson');
  }

 /* document.getElementById('input').onclick = function(e) {
    if (window.File && window.FileReader && window.FileList && window.Blob) {
      // Great success! All the File APIs are supported.
    } else {
      alert('The File APIs are not fully supported in this browser.');
    }

    //var selectedFile = document.getElementById('input').files[0];
    //var geojsonLayer = new L.GeoJSON.AJAX(selectedFile);
    //geojsonLayer.addTo(map);
/*
    var openFile = function(event) {
      var input = event.target;

      var reader = new FileReader();
      reader.onload = function(){
        var dataURL = reader.result;
      };
      reader.readAsDataURL(input.files[0]);
    };
*/
    // get url of .geojson file
    //var url = prompt("Please enter the URL of the .geojson file");
    //alert(url);
    //<input type="file" id="input">
    //var geojsonLayer = new L.GeoJSON.AJAX(url);
    //geojsonLayer.addTo(map);
    //var geolayer = L.geoJson(url).addTo(map);
    //var geojsonLayer = new L.GeoJSON.AJAX("data.geojson").addTo(map);
//  }
  var plotStyle = {
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
      style: plotStyle,
      pointToLayer: function (data, latlng) {
        return L.circleMarker(
        latlng,
        { style: plotStyle }
        );
      }
    }
  }).addTo(map);

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
};

window.onload = function() {
  var convertToLayer, handleZipFile;
  handleZipFile = function(file) {
    var reader;
    reader = new FileReader;
    reader.onload = function() {
      if (reader.readyState !== 2 || reader.error) {
        return;
      } else {
        convertToLayer(reader.result);
      }
    };
    reader.readAsArrayBuffer(file);
  };
  convertToLayer = function(buffer) {
    shp(buffer).then(function(geojson) {
      var layer;
      layer = L.shapefile(geojson);
      featureGroup.addLayer(layer);
    });
  };
  $(document).ready(function() {
    $("#submit").click(function() {
      var file, files;
      files = document.getElementById('file').files;
      if (files.length === 0) {
        return;
      }
      file = files[0];
      if (file.name.slice(-3) !== 'zip') {
        document.getElementById('warning').innerHTML = 'Select .zip file';
        return;
      } else {
        document.getElementById('warning').innerHTML = '';
        handleZipFile(file);
      }
    });
  });
};


// ---
// generated by coffee-script 1.9.2

