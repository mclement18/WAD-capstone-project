const ToDo = {};

ToDo.getToDoList = function() {
  return document.getElementById('todo-list');
};

ToDo.getMyTrips = function() {
  return document.getElementById('my-trips');
};

ToDo.getButtonGroup = function(tripId, from) {
  if (from === 'card') {
    return Card.getCard(`trip-id-${tripId}`).querySelector('.card__footer');
  } else if (from === 'page') {
    return document.querySelector('.stage__nav');
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

ToDo.buildStatusTag = function() {
  const tag = document.createElement('li');
  tag.className = 'tag';
  tag.setAttribute('data-status', 'true');
  tag.textContent = 'ToDo';

  return tag;
};

ToDo.removeTag = function(tripId, from) {
  this.getTagsList(tripId, from).removeChild(this.getStatusTag(tripId, from));
};

ToDo.addTag = function(tripId, from) {
  this.getTagsList(tripId, from).appendChild(this.buildStatusTag());
};

ToDo.removeButton = function(tripId, buttonType, from) {
  const buttonGroup = this.getButtonGroup(tripId, from);
  buttonGroup.removeChild(buttonGroup.querySelector(`[data-${buttonType}=true]`));
};

ToDo.addButton = function(tripId, button, from) {
  this.getButtonGroup(tripId, from).insertAdjacentHTML('afterbegin', button);
};

ToDo.replaceButton = function(tripId, buttonType, button, from) {
  this.removeButton(tripId, buttonType, from);
  this.addButton(tripId, button, from);
  if (buttonType === 'todo-create') {
    this.addTag(tripId, from);
  } else if (buttonType === 'todo-delete') {
    this.removeTag(tripId, from);
  }
};

ToDo.removeButtonFromMyTrips = function(tripId, buttonType) {
  this.removeButton(tripId, buttonType, 'card');
  this.addTag(tripId, 'card');
};

ToDo.removeFromPage = function(tripId, message) {
  Card.remove(`trip-id-${tripId}`, message);
};

ToDo.respond = function(tripId, buttonType, button, message="You don't have any trip in your list.") {
  if (this.getToDoList()) {
    this.removeFromPage(tripId, message);
  } else if (this.getMyTrips()) {
    this.removeButtonFromMyTrips(tripId, buttonType);
  } else if (Card.getCardsList()) {
    this.replaceButton(tripId, buttonType, button, 'card');
  } else {
    this.replaceButton(tripId, buttonType, button, 'page');
  }
};
