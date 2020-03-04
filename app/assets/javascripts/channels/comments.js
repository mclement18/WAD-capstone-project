App.comments = App.cable.subscriptions.create("CommentsChannel", {
  collection: function() {
    return document.getElementById('comments');
  },
  
  connected: function() {
    setTimeout(() => {
      this.followCurrentArticle();
      this.installPageChangeCallback();
    }, 1000);
  },

  received: function(data) {
    if (!this.userIsCurrentUser(data.user_id)) {
      this.collection().insertAdjacentHTML('afterbegin', data.comment);
    }
  },

  userIsCurrentUser: function(user_id) {
    console.log(typeof user_id);
    console.log(typeof document.querySelector('meta[name=current-user]').id);
    return user_id === Number(document.querySelector('meta[name=current-user]').id);
  },

  followCurrentArticle: function() {
    if (this.collection()) {
      articleType = this.collection().getAttribute('data-article-type');
      articleId = this.collection().getAttribute('data-article-id');
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
