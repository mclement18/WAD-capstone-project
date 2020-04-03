const Card = {};

Card.getCard = function(id) {
  return document.getElementById(id);
};

Card.getCardsList = function() {
  return document.querySelector('.cards .cards__list');
};

Card.getCardsContainer = function() {
  return document.querySelector('.cards');
};

Card.buildNotFound = function(message) {
  const p = document.createElement('p');
  p.className = 'not-found';
  p.innerHTML = message;
  
  return p;
};

Card.replaceListWithNotFound = function(message) {
  this.getCardsContainer().removeChild(this.getCardsList());
  this.getCardsContainer().appendChild(this.buildNotFound(message));
};

Card.remove = function(id, message) {
  const card = this.getCard(id);
  let cardPosition;
  for (let i = 0; i < this.getCardsList().children.length; i++) {
    const item = this.getCardsList().children[i];
    if (item === card) {
      cardPosition = i;
      break;
    }
  }

  AnimateCSS.animate(card, 'fadeOut', () => {
    this.getCardsList().removeChild(this.getCard(id));
    if (this.getCardsList().children.length === 0) {
      this.replaceListWithNotFound(message);
    } else {
      AnimateCSS.moveList(this.getCardsList(), 'slideInRight', cardPosition)
    }
  });
  
};
