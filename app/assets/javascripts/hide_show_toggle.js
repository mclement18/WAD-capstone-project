const HideShow = {};

HideShow.getToggle = function() {
 return document.getElementById('hide-show-toggle');
};

HideShow.getContent = function() {
  return document.getElementById('hide-show-content');
};

HideShow.hideContent = function() {
  this.getContent().style = 'display: none;';
};

HideShow.showContent = function() {
 this.getContent().style = '';
};

HideShow.addEventListener = function() {
  document.addEventListener('click', event => {
    const target = event.target;
    if (target === this.getToggle()) {
      event.preventDefault();
      if (target.textContent === 'show') {
        this.showContent();
        target.textContent = 'hide';
      } else if (target.textContent === 'hide') {
        this.hideContent();
        target.textContent = 'show';
      }
    }
  });
}

HideShow.addEventListener();
