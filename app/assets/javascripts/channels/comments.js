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
    if (!this.actionOwnerIsCurrentUser(data.user_id)) {
      switch (data.action) {
        case 'create':
          Comments.insertComment(this.parseData(data).comment);
          break;
        case 'update':
          Comments.replaceComment(this.parseData(data).comment, true);
          break;
        case 'delete':
          Comments.removeComment(`comment_id_${data.comment_id}`, I18n.t('comments.not_found'));
          break;
      }
    }
  },

  actionOwnerIsCurrentUser: function(user_id) {
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
  },

  parseData: function(data) {
    return {
      ...data,
      comment: {
        ...data.comment,
        user: {
          ...data.comment.user,
          path: this.localizePath(data.comment.user.path)
        },
        date: {
          ...data.comment.date,
          text: I18n.t('comments.date', { 
            time: DateHelper.time_ago_in_words_with_parsing(data.comment.date.timeToParse)
          })
        },
        edit: {
          path: this.localizePath(data.comment.edit.path),
          text: I18n.t('links.edit')
        },
        delete: {
          path: this.localizePath(data.comment.delete.path),
          text: I18n.t('links.delete'),
          confirm: I18n.t('notices.are_you_sure')
        }
      }
    };
  },
  
  localizePath: function(path) {
    return `/${I18n.locale}/${path.split('/').slice(2).join('/')}`;
  }
});
