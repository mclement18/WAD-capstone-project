const AnimateCSS = {};

AnimateCSS.animate = function(element, animationName, callback) {
  element.classList.add('animated', animationName)

  function handleAnimationEnd() {
      element.classList.remove('animated', animationName)
      element.removeEventListener('animationend', handleAnimationEnd)

      if (typeof callback === 'function') callback()
  }

  element.addEventListener('animationend', handleAnimationEnd)
};

AnimateCSS.moveList = function(list, animationName, start, callback) {
  for (let i = start; i < list.children.length; i++) {
    const item = list.children[i];
    this.animate(item, animationName);
    if (i === start && typeof callback === 'function') {
      function moveListEnd() {
        item.removeEventListener('animationend', moveListEnd);
        callback();
      }
      
      item.addEventListener('animationend', moveListEnd);
    }
  }
};
