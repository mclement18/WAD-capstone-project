const LocationSelect = {};

LocationSelect.getRegions = function(country) {
  this.getData('/locationselect/regions', { 
    country: country 
  }).then(data => {
    this.setDataCountryAttribute(country);
    this.renderOptions(data, 'trip_region');
  }).catch(error => {
    // display alert
    console.error('There has been a problem with your fetch operation:', error);
  });
};

LocationSelect.getCities = function(country, region) {
  this.getData('/locationselect/cities', { 
    country: country,
    region: region
  }).then(data => {
    this.renderOptions(data, 'trip_city');
  });
};

LocationSelect.getData = async function(url = '', query = {}) {
  const urlWithQuery = url + '?' + new URLSearchParams(query).toString();

  const response = await fetch(urlWithQuery).then();
  if (!response.ok) {
    throw new Error('Network response was not ok');
  }
  return await response.json();
};

LocationSelect.buildOption = function(value, text) {
  const option = document.createElement('option');
  option.value = value;
  option.textContent = text;
  return option;
};

LocationSelect.addOptions = function(selectElement, data) {
  Object.keys(data).forEach(key => {
    selectElement.appendChild(this.buildOption(key, data[key]));
  });
};

LocationSelect.removeOptions = function(selectElement) {
  while (selectElement.firstChild) {
    selectElement.removeChild(selectElement.lastChild);
  }
};

LocationSelect.renderOptions = function(data, selectId) {
  const selectElement = document.getElementById(selectId);
  this.removeOptions(selectElement);
  this.addOptions(selectElement, data);
};

LocationSelect.setDataCountryAttribute = function(country) {
  document.getElementById('trip_region').setAttribute('data-country', country);
};

LocationSelect.addEventListener = function() {
  document.addEventListener('change', event => {
    const target = event.target;
    if (target.id === 'trip_country') {
      this.getRegions(target.value);
    } else if (target.id === 'trip_region' ) {
      this.getCities(target.getAttribute('data-country'), target.value);
    }
  });
};

LocationSelect.addEventListener();
