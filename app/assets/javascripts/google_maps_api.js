const MapsAPI = {};

MapsAPI.getAutocompleteField = function() {
  return document.querySelector('input[data-autocomplete=true]');
};

MapsAPI.getAddressField = function() {
  return document.getElementById('stage_address');
};

MapsAPI.getStaticMap = function() {
  return document.getElementById('staticMap');
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
  if (!this.autocomplete) {
    this.autocomplete = new google.maps.places.Autocomplete(this.getAutocompleteField());
    this.autocomplete.setFields(['formatted_address', 'name']);
    this.autocomplete.addListener('place_changed', this.parseAddress.bind(this));

    // Prevent the form submission when selecting an option with enter
    google.maps.event.addDomListener(this.getAutocompleteField(), 'keydown', event => { 
      if (event.keyCode === 13) { 
          event.preventDefault(); 
      }
    }); 
  }
};

function initAutocomplete() {
  MapsAPI.setAutocomplete();
}
