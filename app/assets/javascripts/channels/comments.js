App.comments = App.cable.subscriptions.create("CommentsChannel", {
  collection: function() {
    return document.querySelector('#comments');
  },
  
  connected: function() {
    setTimeout(() => {
      this.followCurrentArticle();
      this.installPageChangeCallback();
    }, 1000);
  },

  received: function(data) {
    if (!this.userIsCurrentUser(data.user_id)) {
      switch (data.action) {
        case 'create':
          Comments.insertComment(data.comment);
          break;
        case 'update':
          Comments.replaceComment(data.comment, true);
          break;
        case 'delete':
          Comments.removeComment(`comment_id_${data.comment_id}`, data.message);
          break;
      }
    }
  },

  userIsCurrentUser: function(user_id) {
    return user_id === Number(document.querySelector('meta[name=current-user]').id);
  },

  followCurrentArticle: function() {
    if (this.collection()) {
      const articleType = this.collection().getAttribute('data-article-type');
      const articleId = this.collection().getAttribute('data-article-id');
      this.perform('follow', { article_type: articleType, article_id: articleId });
    } else {
      this.perform('unfollow')
    }
  },

  installPageChangeCallback: function() {
    if (!this.installedPageChangeCallback) {
      this.installedPageChangeCallback = true;
      document.addEventListener('turbolinks:load', () => {
        App.comments.followCurrentArticle();
      });
    }
  }
});
