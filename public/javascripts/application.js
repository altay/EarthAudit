function log(msg) {
  if (typeof console != 'undefined') {
    try { console.warn (msg); }    
    catch (e) {}
  }
}

var EA = new function() {
  var BASE_PATH = 'http://74.207.251.143/ea';
  function url(path) { return (BASE_PATH+path); }
  this.debug = true;
  var gcHighlightLayer = false;
  var gcKmzPath = url("/kml/gridcells.kmz?");
  var gcKmzParams = {}; //[{offset:0}, {offset:12000};
  if (this.debug) {
    var cachebust = new Date();
    gcKmzParams['cachebust'] = (cachebust*1);
  }
  this.map = false;
  this.init = function() {
    var mapCenter = new google.maps.LatLng(14.292608964378958, -2.955526406249984);
    var myOptions = {
      zoom: 6,
      center: mapCenter,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    EA.map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
    var currentGLatLng = null;
    google.maps.event.addListener(EA.map, 'click', function(e) {
      currentGLatLng = e.latLng;
      highlightGridCell(currentGLatLng);
    });
    jq('.crop_select').live('change', function(){
      log("select");
      jq.getJSON(url('/gridcells/data'), {crop:jq(this).val(), latlng:currentGLatLng.toUrlValue()}, function(d){ 
        drawChart(d);
      });
    });
    jq.each([0, 2500, 5000, 7500, 10000, 12500, 15000, 17500, 20000, 22500, 25000], function(i,offset){
      var params = gcKmzParams;
      params['offset'] = offset;
      var gcLayer = new google.maps.KmlLayer(gcKmzPath+jq.param(params), { clickable:false, map:EA.map, suppressInfoWindows:true, preserveViewport:true });
    });

    var gcInfoWindow = new google.maps.InfoWindow({content:"<div class='infowindow_container'><div class='gcid_container'>Grid cell #<span class='gcid'></span></div><div class='crop_select_container'></div><div id='chart_container'></div></div>", maxWidth: 10000});
    function highlightGridCell(gLatLng){
      var GRIDBOUNDS = new google.maps.LatLngBounds(
        new google.maps.LatLng(3.0000187, -18.16663),
        new google.maps.LatLng(25.3333565, 16.1667102)
      );
      if (GRIDBOUNDS.contains(gLatLng)) {
        if (gcHighlightLayer) { gcHighlightLayer.setMap(null); } 
        var highlightParams = {latlng:gLatLng.toUrlValue()};
        gcHighlightLayer = new google.maps.KmlLayer(
          (gcKmzPath+jq.param(highlightParams)), 
          {map:EA.map, suppressInfoWindows:true, preserveViewport:true}
        );
        jq.getJSON(url('/gridcells/data'), highlightParams, function(d){ 
          gcInfoWindow.setPosition(gLatLng);
          gcInfoWindow.open(EA.map);
          jq('.gcid').html(d.gcid);
          drawChart(d);
          buildCropSelect(d.crops, gLatLng);
        });
      }
    }
    function buildCropSelect(crops) {
      var html = '';
      if (crops.length>0){
        html = "Crop: <select class='crop_select'>";
        jq.each(crops, function(i, c) {
          html += "<option value='"+c+"'>"+c+"</option>";
        });
      } else { 
        html = "<em>No crop data for this grid cell</em>";
      }
      jq('.crop_select_container').html(html);
    }
  }
  function drawChart(data) {
    var plotOptions = {
      xaxis: { mode: "time" },
      grid: { markings: [] }
    }
    // planting dates
    if (data && data.plantings && data.plantings[0] && data.plantings[0].planting) {
      var p_start = data.plantings[0].planting.start;
      var p_end = data.plantings[0].planting.end;
      if (p_start>p_end) { // this happens if the planting period wraps around (i.e. crosses dec-jan)
        plotOptions.grid.markings.push({
          xaxis: {
            from: 1*(new Date(p_start)), 
            to: 1*(new Date(2011,0,1)) // end of the year
          }, 
          color: "#D6E3B5" 
        });
        p_start = 1*(new Date(2010,0,1)); // beginning of the year
      }
      plotOptions.grid.markings.push({
        xaxis: {
          from: 1*(new Date(p_start)), 
          to: 1*(new Date(p_end))
        }, 
        color: "#D6E3B5" 
      });
    }
    // harvest dates
    if (data && data.plantings && data.plantings[0] && data.plantings[0].harvest) {
      var start_stamp = data.plantings[0].harvest.start;
      var end_stamp = data.plantings[0].harvest.end;
      var h_start = 1*(new Date(start_stamp));
      var h_end = 1*(new Date(end_stamp));
      var halfway = ((start_stamp+end_stamp)/2)
      var h_50 = 1*(new Date(halfway));
      var h_25 = 1*(new Date((start_stamp+halfway)/2));
      var h_75 = 1*(new Date((halfway+end_stamp)/2));
      // horizontal line representing max value
      plotOptions.grid.markings.push({
        xaxis: { from: h_25, to: h_75 }, 
        yaxis: { from: 150, to: 150 },
        color: "#333333"
      });
      // vertical line to max value
      plotOptions.grid.markings.push({
        xaxis: { from: h_50, to: h_50 }, 
        yaxis: { from: 90, to: 150 },
        color: "#aaaaaa"
      });
      // upper quartile
      plotOptions.grid.markings.push({
        xaxis: { from: h_start, to: h_end }, 
        yaxis: { from: 60, to: 90 },
        color: "#FFCCCB"
      });
      // horizontal line representing median yield
      plotOptions.grid.markings.push({
        xaxis: { from: h_start, to: h_end }, 
        yaxis: { from: 60, to: 60 },
        color: "#000000"
      });
      // lower quartile
      plotOptions.grid.markings.push({
        xaxis: { from: h_start, to: h_end }, 
        yaxis: { from: 40, to: 60 },
        color: "#FFCCCB"
      });
      // vertical line to min value
      plotOptions.grid.markings.push({
        xaxis: { from: h_50, to: h_50 }, 
        yaxis: { from: 20, to: 40 },
        color: "#aaaaaa"
      });
      // horizontal line representing min value
      plotOptions.grid.markings.push({
        xaxis: { from: h_25, to: h_75 }, 
        yaxis: { from: 20, to: 20 },
        color: "#333333"
      });
    }

    //log(plotOptions);
    jq.plot(jq("#chart_container"), [
        {data: ((data && data.climate) ? data.climate.precipitation : null)},
        {data: ((data && data.climate) ? data.climate.temperature : null)}
      ], 
      plotOptions
    );
  }
}
