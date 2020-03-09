const Comments = {};

Comments.getList = function() {
  return document.getElementById('comments');
};

Comments.getComment = function(commentId) {
  return document.getElementById(`comment_id_${commentId}`);
};

Comments.insertComment = function(comment) {
  this.getList().insertAdjacentHTML('afterbegin', comment);
};

Comments.resetCommentForm = function(form) {
  document.getElementById('new_comment').outerHTML = form;
};

Comments.replaceComment = function(commentId, updatedComment) {
  this.getComment(commentId).outerHTML = updatedComment;
};

Comments.removeComment = function(commentId) {
  this.getList().removeChild(this.getComment(commentId));
};
