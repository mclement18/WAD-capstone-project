const LocationSelect = {};

LocationSelect.getRegions = function(country) {
  this.getData('/locationselect/regions.json', { 
    country: country 
  }).then(data => {
    this.setDataCountryAttribute(country);
    this.renderOptions(data, this.regionsSelect());
    if (this.citiesSelect()) {
      this.resetCities();
    }
  }).catch(error => {
    // display alert
    console.error('There has been a problem with your fetch operation:', error);
  });
};

LocationSelect.getCities = function(country, region) {
  this.getData('/locationselect/cities.json', { 
    country: country,
    region: region
  }).then(data => {
    this.renderOptions(data, this.citiesSelect());
  }).catch(error => {
    // display alert
    console.error('There has been a problem with your fetch operation:', error);
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

LocationSelect.regionsSelect = function() {
  return document.getElementById('trip_region');
};

LocationSelect.citiesSelect = function() {
  return document.querySelector('select#trip_city');
};

LocationSelect.cityInput = function() {
  return document.querySelector('input#trip_city');
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

LocationSelect.renderOptions = function(data, selectElement) {
  this.removeOptions(selectElement);
  this.addOptions(selectElement, data);
};

LocationSelect.setDataCountryAttribute = function(country) {
  this.regionsSelect().setAttribute('data-country', country);
};

LocationSelect.resetCities = function() {
  this.removeOptions(this.citiesSelect());
  this.addOptions(this.citiesSelect(), { '': 'None' })
};

LocationSelect.buildCityInput = function() {
  const input = document.createElement('input');
  input.id = 'trip_city';
  input.className = 'input-field';
  input.name = 'trip[city]';
  return input;
};

LocationSelect.buildCitiesSelect = function() {
  const select = document.createElement('select');
  select.id = 'trip_city';
  select.className = 'input-field';
  select.name = 'trip[city]';
  return select;
};

LocationSelect.changeToCityInput = function() {
  const inputGroup = this.citiesSelect().parentElement;
  inputGroup.removeChild(this.citiesSelect());
  inputGroup.insertBefore(this.buildCityInput(), inputGroup.lastElementChild);
};

LocationSelect.changeToCitiesSelect = function() {
  const inputGroup = this.cityInput().parentElement;
  inputGroup.removeChild(this.cityInput());
  inputGroup.insertBefore(this.buildCitiesSelect(), inputGroup.lastElementChild);
  this.getCities(this.regionsSelect().getAttribute('data-country'), this.regionsSelect().value);
};

LocationSelect.addEventListeners = function() {
  document.addEventListener('change', event => {
    const target = event.target;
    if (target.id === 'trip_country') {
      this.getRegions(target.value);
    } else if (target.id === 'trip_region' && this.citiesSelect() ) {
      this.getCities(target.getAttribute('data-country'), target.value);
    }
  });

  document.addEventListener('click', event => {
    const target = event.target;
    if (target.id == 'city-input-change') {
      switch (target.getAttribute('data-action')) {
        case 'getInput':
          this.changeToCityInput();
          target.textContent = target.getAttribute('data-select');
          target.setAttribute('data-action', 'getSelect');
          break;
        case 'getSelect':
          this.changeToCitiesSelect();
          target.textContent = target.getAttribute('data-input');
          target.setAttribute('data-action', 'getInput');
          break;
      }
    }
  });
};

LocationSelect.addEventListeners();
