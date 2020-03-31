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
  if (this.getNotFound()) {
    this.getList().removeChild(this.getNotFound());
  }
  this.getList().insertAdjacentHTML('afterbegin', comment);
};

Comments.resetCommentForm = function(form) {
  document.getElementById('new_comment').outerHTML = form;
};

Comments.replaceComment = function(commentId, updatedComment) {
  this.getComment(commentId).outerHTML = updatedComment;
};

Comments.removeComment = function(commentId, message) {
  this.getList().removeChild(this.getComment(commentId));
  if (this.getList().children.length === 0) {
    this.getList().appendChild(this.buildNotFound(message));
  }
};
