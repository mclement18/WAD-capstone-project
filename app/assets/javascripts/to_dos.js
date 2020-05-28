const ToDo = {};

ToDo.button = {
  text: '',
  path: '',
  tripId: 0
};

ToDo.getLocale = function() {
  return window.location.pathname.split('/')[1];
};

ToDo.getToDoList = function() {
  return document.querySelector('#todo-list');
};

ToDo.getMyTrips = function() {
  return document.querySelector('#my-trips');
};

ToDo.getButtonGroup = function(tripId, from) {
  if (from === 'card') {
    return Card.getCard(`trip-id-${tripId}`).querySelector('.card__footer');
  } else if (from === 'page') {
    return document.querySelector('.resource-show__nav');
  }
};

ToDo.getTagsList = function(tripId, from) {
  if (from === 'card') {
    return Card.getCard(`trip-id-${tripId}`).querySelector('.tags-list');
  } else if (from === 'page') {
    return document.querySelector('.tags-list');
  }
};

ToDo.getStatusTag = function(tripId, from) {
  if (from === 'card') {
    return Card.getCard(`trip-id-${tripId}`).querySelector('[data-status=true]');
  } else if (from === 'page') {
    return document.querySelector('[data-status=true]');
  }
};

ToDo.buildStatusTag = function(text) {
  const tag = document.createElement('li');
  tag.className = 'tag';
  tag.setAttribute('data-status', 'true');
  tag.textContent = text;

  return tag;
};

ToDo.removeTag = function(tripId, from) {
  this.getTagsList(tripId, from).removeChild(this.getStatusTag(tripId, from));
};

ToDo.addTag = function(tripId, from, text) {
  this.getTagsList(tripId, from).appendChild(this.buildStatusTag(text));
};

ToDo.buildRemoveButton = function(button) {
  const removeButton = document.createElement('a');
  removeButton.href = button.path;
  removeButton.textContent = button.text;
  removeButton.className = 'btn btn--secondary';
  removeButton.rel = 'nofollow';
  removeButton.setAttribute('data-todo-delete', 'true');
  removeButton.setAttribute('data-remote', 'true');
  removeButton.setAttribute('data-method', 'delete');

  return removeButton;
};

ToDo.buildCreateButton = function(button) {
  const submitButton = document.createElement('button');
  submitButton.textContent = button.text;
  submitButton.name = 'button';
  submitButton.type = 'submit';
  submitButton.className = 'btn';

  const tripIdInput = document.createElement('input');
  tripIdInput.type = 'hidden';
  tripIdInput.name = 'trip_id';
  tripIdInput.name = 'trip_id';
  tripIdInput.value = button.tripId.toString();

  const hiddenInput = document.createElement('input');
  hiddenInput.type = 'hidden';
  hiddenInput.name = 'utf8';
  hiddenInput.value = '✓';
  
  const createButton = document.createElement('form');
  createButton.className = 'btn--form';
  createButton.action = button.path;
  createButton.method = 'post';
  createButton.setAttribute('data-todo-create', 'true');
  createButton.setAttribute('data-remote', 'true');
  createButton.setAttribute('accept-charset', 'UTF-8');
  createButton.appendChild(hiddenInput);
  createButton.appendChild(tripIdInput);
  createButton.appendChild(submitButton);

  return createButton;
};

ToDo.removeButton = function(tripId, buttonType, from) {
  const buttonGroup = this.getButtonGroup(tripId, from);
  buttonGroup.removeChild(buttonGroup.querySelector(`[data-${buttonType}=true]`));
};

ToDo.addButton = function(tripId, button, from) {
  const buttonGroup = this.getButtonGroup(tripId, from);
  buttonGroup.insertBefore(button, buttonGroup.firstChild);
};

ToDo.replaceButton = function(tripId, buttonType, button, from, tagText) {
  this.removeButton(tripId, buttonType, from);
  this.addButton(tripId, button, from);
  if (buttonType === 'todo-create') {
    this.addTag(tripId, from, tagText);
  } else if (buttonType === 'todo-delete') {
    this.removeTag(tripId, from);
  }
};

ToDo.removeButtonFromMyTrips = function(tripId, buttonType, tagText) {
  this.removeButton(tripId, buttonType, 'card');
  this.addTag(tripId, 'card', tagText);
};

ToDo.removeFromPage = function(tripId, message) {
  Card.remove(`trip-id-${tripId}`, message);
};

ToDo.respond = function(tripId, buttonType=null, button=null, tagText='ToDo', message="You don't have any trip in your list.") {
  if (this.getToDoList()) {
    this.removeFromPage(tripId, message);
  } else if (this.getMyTrips()) {
    this.removeButtonFromMyTrips(tripId, buttonType, tagText);
  } else if (Card.getCardsList()) {
    this.replaceButton(tripId, buttonType, button, 'card', tagText);
  } else {
    this.replaceButton(tripId, buttonType, button, 'page', tagText);
  }
};
