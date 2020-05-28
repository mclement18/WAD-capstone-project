const Comments = {};

Comments.comment = {
  id: '',
  body: '',
  isForm: false,
  user: {
    id: 0,
    name: '',
    avatar_url: '',
    path: ''
  },
  date: {
    formated: '',
    text: ''
  },
  edit: {
    text: '',
    path: ''
  },
  delete: {
    text: '',
    path: '',
    confirm: ''
  },
  update: {
    text: '',
    path: ''
  },
  cancel: {
    text: '',
    path: ''
  },
  label: {
    text: '',
    id: ''
  }
};

Comments.getList = function() {
  return document.querySelector('#comments');
};

Comments.getComment = function(commentId) {
  return document.querySelector(`#${commentId}`);
};

Comments.buildNotFound = function(message) {
  const p = document.createElement('p');
  p.className = 'not-found';
  p.textContent = message;
  return p;
};

Comments.getNotFound = function() {
  return document.querySelector('.not-found');
};

Comments.canEditComment = function(comment) {
  return (
    Number(document.querySelector('meta[name=current-user]').id) === comment.user.id 
    || document.querySelector('meta[name=current-user-role]').id === 'admin'
  );
};

Comments.buildMediaImage = function(comment) {
  const avatar = document.createElement('img');
  avatar.src = comment.user.avatar_url;
  avatar.alt = `${comment.user.name} avatar`;
  avatar.className = 'avatar avatar--medium';
  
  const avatarLink = document.createElement('a');
  avatarLink.href = comment.user.path;
  avatarLink.appendChild(avatar);

  const mediaImage = document.createElement('div');
  mediaImage.className = 'media__image';
  mediaImage.appendChild(avatarLink);

  return mediaImage;
};

Comments.buildMediaTitle = function(comment) {
  const userName = document.createElement('h3');
  userName.textContent = comment.user.name;
  userName.className = 'user';

  const userLink = document.createElement('a');
  userLink.href = comment.user.path;
  userLink.appendChild(userName);

  const timeStamp = document.createElement('time');
  timeStamp.dateTime = comment.date.formated;
  timeStamp.textContent = comment.date.text;

  const date = document.createElement('span');
  date.className = 'date';
  date.appendChild(timeStamp);

  const mediaTitle = document.createElement('div');
  mediaTitle.className = 'media__title';
  mediaTitle.appendChild(userLink);
  mediaTitle.appendChild(date);

  return mediaTitle;
};

Comments.buildMediaContent = function(comment) {
  const mediaBody = document.createElement('div');
  mediaBody.className = 'media__body';

  const mediaAction = document.createElement('div');
  mediaAction.className = 'media__action';

  const mediaContent = document.createElement('div');
  mediaContent.className = 'media__content';
  mediaContent.appendChild(this.buildMediaTitle(comment));
  mediaContent.appendChild(mediaBody);
  mediaContent.appendChild(mediaAction);

  return mediaContent;
};

Comments.buildCommonElements = function(comment) {
  return [
    this.buildMediaImage(comment),
    this.buildMediaContent(comment)
  ];
};

Comments.buildCommentSpecificElements = function(comment, action=false) {
  const text = document.createElement('p');
  text.textContent = comment.body;
  text.className = 'text';

  if (action){
    const editButton = document.createElement('a');
    editButton.className = 'btn';
    editButton.href = comment.edit.path;
    editButton.textContent = comment.edit.text;
    editButton.setAttribute('data-remote', 'true');
    editButton.setAttribute('data-method', 'get');
  
    const deleteButton = document.createElement('a');
    deleteButton.href = comment.delete.path;
    deleteButton.textContent = comment.delete.text;
    deleteButton.className = 'btn btn--secondary';
    deleteButton.rel = 'nofollow';
    deleteButton.setAttribute('data-remote', 'true');
    deleteButton.setAttribute('data-method', 'delete');
    deleteButton.setAttribute('data-confirm', comment.delete.confirm);

    return [text, editButton, deleteButton];
  }

  return text;
};

Comments.buildComment = function(comment) {
  const [mediaImage, mediaContent] = this.buildCommonElements(comment);

  if (this.canEditComment(comment)) {
    const [text, editButton, deleteButton] = this.buildCommentSpecificElements(comment, true);
    mediaContent.querySelector('.media__body').appendChild(text);
    mediaContent.querySelector('.media__action').appendChild(editButton);
    mediaContent.querySelector('.media__action').appendChild(deleteButton);
  } else {
    mediaContent.querySelector('.media__body').appendChild(this.buildCommentSpecificElements(comment));
    mediaContent.removeChild(mediaContent.lastElementChild);
  }

  const commentElement = document.createElement('div');
  commentElement.id = comment.id;
  commentElement.className = 'media comment';
  commentElement.setAttribute('data-user-id', comment.user.id);
  commentElement.appendChild(mediaImage);
  commentElement.appendChild(mediaContent);

  return commentElement;
};

Comments.buildEditFormSpecificElements = function(editComment) {
  const textLabel = document.createElement('label');
  textLabel.textContent = editComment.label.text;
  textLabel.setAttribute('for', editComment.label.id);
  textLabel.className = 'input-label';

  const textArea = document.createElement('textarea');
  textArea.value = editComment.body;
  textArea.id = editComment.label.id;
  textArea.className = 'input-field input-field--textarea';
  textArea.name = 'comment[body]';
  textArea.maxLength = '300';
  textArea.placeholder = 'Max 300 characters...';

  const cancelLink = document.createElement('a');
  cancelLink.href = editComment.cancel.path;
  cancelLink.textContent = editComment.cancel.text;
  cancelLink.className = 'link';
  cancelLink.setAttribute('data-remote', 'true');
  cancelLink.setAttribute('data-method', 'get');

  const submitButton = document.createElement('input');
  submitButton.value = editComment.update.text;
  submitButton.className = 'btn btn--primary';
  submitButton.name = 'commit';
  submitButton.type = 'submit';
  submitButton.setAttribute('data-disable-with', editComment.update.text);

  return [textLabel, textArea, cancelLink, submitButton];
};

Comments.buildEditForm = function(editComment) {
  const [mediaImage, mediaContent] = this.buildCommonElements(editComment);
  const [textLabel, textArea, cancelLink, submitButton] = this.buildEditFormSpecificElements(editComment);
  
  mediaContent.querySelector('.media__body').appendChild(textLabel);
  mediaContent.querySelector('.media__body').appendChild(textArea);
  mediaContent.querySelector('.media__action').appendChild(cancelLink);
  mediaContent.querySelector('.media__action').appendChild(submitButton);

  const hiddenCharset = document.createElement('input');
  hiddenCharset.type = 'hidden';
  hiddenCharset.name = 'utf8';
  hiddenCharset.value = '✓';

  const hiddenMethod = document.createElement('input');
  hiddenMethod.type = 'hidden';
  hiddenMethod.name = '_method';
  hiddenMethod.value = 'patch';

  const editForm = document.createElement('form');
  editForm.id = editComment.id;
  editForm.className = 'media comment comment-form';
  editForm.setAttribute('data-user-id', editComment.user.id);
  editForm.action = editComment.update.path;
  editForm.method = 'post';
  editForm.setAttribute('data-remote', 'true');
  editForm.setAttribute('accept-charset', 'UTF-8');
  editForm.appendChild(hiddenCharset);
  editForm.appendChild(hiddenMethod);
  editForm.appendChild(mediaImage);
  editForm.appendChild(mediaContent);

  return editForm;
};

Comments.insertComment = function(comment) {
  const newComment = this.buildComment(comment);
  if (this.getNotFound()) {
    this.getList().removeChild(this.getNotFound());
    this.getList().appendChild(newComment);
    AnimateCSS.animate(this.getList().firstElementChild, 'slideInRight');
  } else {
    AnimateCSS.moveList(this.getList(), 'slideOutDown', 0, () => {
      this.getList().insertBefore(newComment, this.getList().firstElementChild);
      AnimateCSS.animate(this.getList().firstElementChild, 'slideInRight');
  });
  }
};

Comments.resetCommentForm = function() {
  document.querySelector('#new_comment #comment_body').value = '';
};

Comments.replaceComment = function(comment, animate=false) {
  const oldComment = this.getComment(comment.id);
  const nextComment = oldComment.nextElementSibling;
  const newComment = comment.isForm ? this.buildEditForm(comment) : this.buildComment(comment);

  const callback = () => {
    this.getList().removeChild(oldComment);
    if (nextComment) {
      this.getList().insertBefore(newComment, nextComment);
    } else {
      this.getList().appendChild(newComment);
    }
    if (animate) AnimateCSS.animate(newComment, 'slideInRight');
  }

  animate ? AnimateCSS.animate(oldComment, 'fadeOut', callback) : callback();
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
