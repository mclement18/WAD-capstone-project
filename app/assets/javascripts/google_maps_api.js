const MapsAPI = {};

MapsAPI.getAutocompleteField = function() {
  return document.querySelector('input[data-autocomplete=true]');
};

MapsAPI.getAddressField = function() {
  return document.querySelector('#stage_address');
};

MapsAPI.getStaticMap = function() {
  return document.querySelector('#staticMap');
};

MapsAPI.setAddressField = function(address) {
  this.getAddressField().value = address;
};


MapsAPI.setStaticMapLocation = function(address) {
  const staticMapSrcArray = this.getStaticMap().src.split('=');
  staticMapSrcArray.pop();
  staticMapSrcArray.push(encodeURIComponent(address));
  this.getStaticMap().src = staticMapSrcArray.join('=');
};

MapsAPI.parseAddress = function() {
  const place = this.autocomplete.getPlace();
  let address = '';
  if (place.formatted_address.includes(place.name)) {
    address = place.formatted_address;
  } else {
    address = [place.name, place.formatted_address].join(', ');
  }

  this.setAddressField(address);
  this.setStaticMapLocation(address);
};

MapsAPI.setAutocomplete = function() {
  this.autocomplete = new google.maps.places.Autocomplete(this.getAutocompleteField());
  this.autocomplete.setFields(['formatted_address', 'name']);
  this.autocomplete.addListener('place_changed', this.parseAddress.bind(this));

  // Prevent the form submission when selecting an option with enter
  google.maps.event.addDomListener(this.getAutocompleteField(), 'keydown', event => { 
    if (event.keyCode === 13) { 
        event.preventDefault(); 
    }
  }); 
};

MapsAPI.getStageDirections = function() {
  return JSON.parse(document.querySelector('meta[name=directions]').getAttribute('value'));
};

MapsAPI.getStageTravelMode = function() {
  return document.querySelector('meta[name=travelMode]').getAttribute('value').toUpperCase();
};

MapsAPI.createMap = function() {
  return new google.maps.Map(document.querySelector('#map'));
};

MapsAPI.typecastRouteFromServer = function(routes){
  routes.forEach(route => {
    route.bounds = this.asBounds(route.bounds);
    route.overview_path = this.asPath(route.overview_polyline);
    route.legs.forEach(leg => {
      leg.start_location = this.asLatLng(leg.start_location);
      leg.end_location   = this.asLatLng(leg.end_location);
  
      leg.steps.forEach(step => {
        step.start_location = this.asLatLng(step.start_location);
        step.end_location   = this.asLatLng(step.end_location);
        step.path = this.asPath(step.polyline);
      });
    });
  });

  return routes;
};

MapsAPI.asBounds = function(boundsObject){
  return new google.maps.LatLngBounds(this.asLatLng(boundsObject.southwest), this.asLatLng(boundsObject.northeast));
};

MapsAPI.asLatLng = function(latLngObject){
  return new google.maps.LatLng(latLngObject.lat, latLngObject.lng);
};

MapsAPI.asPath = function(encodedPolyObject){
  return google.maps.geometry.encoding.decodePath(encodedPolyObject.points);
};

MapsAPI.renderRoutes = function(map, stageDirections, request, suppressMarkers=false, preserveViewport=false) {
  const directionsRenderer = new google.maps.DirectionsRenderer();
  directionsRenderer.setOptions({
    directions: {
      routes: this.typecastRouteFromServer([stageDirections]),
      request: request
    },
    draggable: false,
    map: map,
    suppressMarkers: suppressMarkers,
    preserveViewport: preserveViewport
  });
};

MapsAPI.attachInstructionText = function(stepDisplay, marker, instructions, map) {
  google.maps.event.addListener(marker, 'click', function() {
    // Open an info window when the marker is clicked on, containing the text
    // of the step.
    stepDisplay.setContent(instructions);
    stepDisplay.open(map, marker);
  });
};

MapsAPI.renderSteps = function(routes, map) {
  const stepDisplay = new google.maps.InfoWindow;
  routes.forEach(route => {
    route.legs[0].steps.forEach(step => {
      const marker = new google.maps.Marker;
      marker.setMap(map);
      marker.setPosition(step.start_location);
      this.attachInstructionText(stepDisplay, marker, step.html_instructions, map);
    });
  });
};

MapsAPI.renderStartEnd = function(route, map) {
  const stepDisplay = new google.maps.InfoWindow;
  const startAndEnd = [{location: route.legs[0].start_location}, {location: route.legs[0].end_location}];
  startAndEnd[0].address = route.legs[0].start_address;
  startAndEnd[1].address = route.legs[0].end_address;
  startAndEnd.forEach(point => {
    const marker = new google.maps.Marker;
    marker.setMap(map);
    marker.setPosition(point.location);
    this.attachInstructionText(stepDisplay, marker, point.address, map);
  });
};

MapsAPI.renderStageMap = function() {
  const map = this.createMap();
  this.renderRoutes(map, this.getStageDirections(), {
    travelMode: this.getStageTravelMode()
  });
  this.renderSteps([this.getStageDirections()], map);
};

MapsAPI.renderTripMap = function() {
  const map = this.createMap();
  const mapBounds = new google.maps.LatLngBounds();
  this.getStageDirections().forEach(directions => {
    this.renderRoutes(map, directions, {
      travelMode: this.getStageTravelMode()
    }, true, true);
    this.renderStartEnd(directions, map);
    mapBounds.union(directions.bounds);
  });
  map.fitBounds(mapBounds);
};

MapsAPI.reset = function() {
  document.addEventListener('turbolinks:before-cache', () => {
    window.google = {};
  });
};

MapsAPI.reset();

// Callback functions for URL
function initAutocomplete() {
  MapsAPI.setAutocomplete();
}

function initStageMap() {
  MapsAPI.renderStageMap();
}

function initTripMap() {
  MapsAPI.renderTripMap();
}
