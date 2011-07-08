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
    google.maps.event.addListener(EA.map, 'click', function(e) {
      highlightGridCell(e.latLng);
    });
    jq.each([0, 2500, 5000, 7500, 10000, 12500, 15000, 17500, 20000, 22500, 25000], function(i,offset){
      var params = gcKmzParams;
      params['offset'] = offset;
      var gcLayer = new google.maps.KmlLayer(gcKmzPath+jq.param(params), { clickable:false, map:EA.map, suppressInfoWindows:true, preserveViewport:true });
    });

    var gcInfoWindow = new google.maps.InfoWindow({content:"<div class='infowindow_container'><div class='gcid_container'>Grid cell #<span class='gcid'></span></div><div id='chart_div'></div></div>", maxWidth: 10000});
    function highlightGridCell(gLatLng){
      var GRIDBOUNDS = new google.maps.LatLngBounds(
        new google.maps.LatLng(3.0000187, -18.16663),
        new google.maps.LatLng(25.3333565, 16.1667102)
      );
      if (GRIDBOUNDS.contains(gLatLng)) {
        if (gcHighlightLayer) { gcHighlightLayer.setMap(null); } 
        //var highlightParams = {gcid:gcid};
        var highlightParams = {latlng:gLatLng.toUrlValue()};
        gcHighlightLayer = new google.maps.KmlLayer(
          (gcKmzPath+jq.param(highlightParams)), 
          {map:EA.map, suppressInfoWindows:true, preserveViewport:true}
        );
        jq.getJSON(url('/gridcells/data'), highlightParams, function(d){ 
          //gcInfoWindow.setContent("FID: " + d.grid_cell.fid);
          gcInfoWindow.setPosition(gLatLng);
          gcInfoWindow.open(EA.map);
          log(d);
          jq('.gcid').html(d.gcid);
          drawChart(d.climate);
        });
      }
    }
  }
  function drawChart(climateData) {
    jq.plot(jq("#chart_div"), [
        {data: climateData.precipitation},
        {data: climateData.temperature}
    ], { 
      xaxis: { mode: "time" },
      grid: {
        markings: [
          { xaxis: { from: 1*(new Date(2010, 5)), to: 1*(new Date(2010, 7)) }, color: "#D6E3B5" }
        ]
      }
    });
    /*
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Month');
    data.addColumn('number', 'Precipitation (mm/month)');
    data.addColumn('number', 'Temperature (degrees C)');
    data.addRows(climateData);
    setTimeout(function(){  // without timeout, sometimes chart doesn't render cause infowindow doesn't exist yet
      //var opts = { chartArea: { left: 200 } };
      //var opts = {chxt: 'x'}
      //var chart = new google.visualization.LineChart(document.getElementById('chart_div'), opts);
      var chart = new google.visualization.ImageChart(document.getElementById('chart_div'));
      chart.draw(data, {width: 500, height: 280, chxt:'x,y,r'});
    }, 100);
    */
  }
}
