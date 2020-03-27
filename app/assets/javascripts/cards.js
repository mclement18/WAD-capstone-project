const Card = {};

Card.getCard = function(id) {
  return document.getElementById(id);
};

Card.getCardsList = function() {
  return document.querySelector('.cards .cards__list');
}

Card.remove = function(id) {
  this.getCardsList().removeChild(this.getCard(id));
};
