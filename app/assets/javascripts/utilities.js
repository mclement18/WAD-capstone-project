const Util = {};

Util.insertAfter = function(newChild, refChild) {
  if (refChild.nextSibling) {
    refChild.parentElement.insertBefore(newChild, refChild.nextSibling)
  } else {
    refChild.parentElement.appendChild(newChild);
  }
};
