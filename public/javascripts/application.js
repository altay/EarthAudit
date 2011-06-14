function log(msg) {
  if (typeof console != 'undefined') {
    try { console.warn (msg); }    
    catch (e) {}
  }
}

var EA = new function() {
  this.debug = true;
  var gcHighlightLayer = false;
  var gcKmzPath = "http://74.207.251.143/ea/kml/gridcells.kmz?";
  var gcKmzParams = {}; //[{offset:0}, {offset:12000};
  if (this.debug) {
    var cachebust = new Date();
    gcKmzParams['cachebust'] = (cachebust*1);
  }
  this.map = false;
  this.init = function() {
    var latlng = new google.maps.LatLng(14.292608964378958, -2.955526406249984);
    var myOptions = {
      zoom: 6,
      center: latlng,
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
      /*
      google.maps.event.addListener(gcLayer, 'click', function(e) {
        highlightGridCell(e.featureData.name);
      });
      */
    });

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
      }
    }
  }
}
