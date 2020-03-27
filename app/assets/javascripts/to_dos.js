const ToDo = {};

ToDo.getToDoList = function() {
  return document.getElementById('todo-list');
};

ToDo.getCardFooter = function(tripId) {
  return Card.getCard(`trip-id-${tripId}`).querySelector('.card__footer');
};

ToDo.getTagsList = function(tripId) {
  return Card.getCard(`trip-id-${tripId}`).querySelector('.card__tags');
};

ToDo.getStatusTag = function(tripId) {
  return Card.getCard(`trip-id-${tripId}`).querySelector('[data-status=true]');
};

ToDo.buildStatusTag = function() {
  const tag = document.createElement('li');
  tag.className = 'tag';
  tag.setAttribute('data-status', 'true');
  tag.textContent = 'ToDo';

  return tag;
};

ToDo.removeTag = function(tripId) {
  this.getTagsList(tripId).removeChild(this.getStatusTag(tripId));
};

ToDo.addTag = function(tripId) {
  this.getTagsList(tripId).appendChild(this.buildStatusTag());
};

ToDo.removeButtonToCard = function(tripId, buttonType) {
  const cardFooter = this.getCardFooter(tripId);
  cardFooter.removeChild(cardFooter.querySelector(`[data-${buttonType}=true]`));
};

ToDo.addButtonToCard = function(tripId, button) {
  this.getCardFooter(tripId).insertAdjacentHTML('afterbegin', button);
};

ToDo.replaceCardButton = function(tripId, buttonType, button) {
  this.removeButtonToCard(tripId, buttonType);
  this.addButtonToCard(tripId, button);
  if (buttonType === 'todo-create') {
    this.addTag(tripId);
  } else if (buttonType === 'todo-delete') {
    this.removeTag(tripId);
  }
};

ToDo.removeFromPage = function(tripId, message) {
  Card.remove(`trip-id-${tripId}`, message);
};

ToDo.respond = function(tripId, buttonType, button, message="You don't have any trip in your list.") {
  if (this.getToDoList()) {
    this.removeFromPage(tripId, message);
  } else if (this.getCardFooter(tripId)) {
    this.replaceCardButton(tripId, buttonType, button);
  }
}
