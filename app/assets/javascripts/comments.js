const Comments = {};

Comments.getList = function() {
  return document.getElementById('comments');
};

Comments.getComment = function(commentId) {
  return document.getElementById(`comment_id_${commentId}`);
};

Comments.buildNotFound = function(message) {
  const p = document.createElement('p');
  p.className = 'not-found';
  p.innerHTML = message;
  return p;
};

Comments.getNotFound = function() {
  return document.querySelector('.not-found');
};

Comments.insertComment = function(comment) {
  const doc = new DOMParser().parseFromString(comment, 'text/html');
  if (this.getNotFound()) {
    this.getList().removeChild(this.getNotFound());
    this.getList().appendChild(doc.body.firstElementChild);
    console.log(this.getList().firstElementChild)
    AnimateCSS.animate(this.getList().firstElementChild, 'slideInRight');
  } else {
    AnimateCSS.moveList(this.getList(), 'slideOutDown', 0, () => {
      this.getList().insertBefore(doc.body.firstElementChild, this.getList().firstElementChild);
      AnimateCSS.animate(this.getList().firstElementChild, 'slideInRight');
  });
  }
};

Comments.resetCommentForm = function(form) {
  document.getElementById('new_comment').outerHTML = form;
};

Comments.replaceComment = function(commentId, updatedComment) {
  this.getComment(commentId).outerHTML = updatedComment;
};

Comments.removeComment = function(commentId, message) {
  const comment = this.getComment(commentId);
  let commentPosition;
  for (let i = 0; i < this.getList().children.length; i++) {
    const item = this.getList().children[i];
    if (item === comment) {
      commentPosition = i;
      break;
    }
  }
  AnimateCSS.animate(comment, 'fadeOutRight', () => {
    this.getList().removeChild(this.getComment(commentId));
    if (this.getList().children.length === 0) {
      this.getList().appendChild(this.buildNotFound(message));
    } else {
      AnimateCSS.moveList(this.getList(), 'slideInUp', commentPosition);
    }
  });
};
