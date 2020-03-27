const User = {};

User.removeFromPage = function(userId) {
  Card.remove(`user-id-${userId}`, '');
};
