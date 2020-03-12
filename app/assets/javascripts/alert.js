const Alert = {};

Alert.getMain = function() {
  return document.getElementById('alert-insertion');
};

Alert.getAlert = function(id) {
  return document.getElementById(id);
};

Alert.getAlerts = function() {
  return document.querySelectorAll('.alert');
};

Alert.render = function(alert) {
  this.getMain().insertAdjacentHTML('afterbegin', alert);
  const newAlert = this.getMain().firstElementChild;
  this.autoDismiss(newAlert.id);
  this.addDismissActionToButton(newAlert);
};

Alert.dismiss = function(id) {
  this.getMain().removeChild(this.getAlert(id));
};

Alert.autoDismiss = function(id) {
  setTimeout(() => {
    this.dismiss(id);
  }, 10000);
};

Alert.addDismissActionToButton = function(alert) {
  alert.addEventListener('click', event => {
    const target = event.target;
    if (target.tagName === 'BUTTON') {
      this.dismiss(alert.id)
    }
  });
};

Alert.addEventListeners = function() {
  document.addEventListener('turbolinks:load', () => {
    this.getAlerts().forEach(alert => {
      this.autoDismiss(alert.id);
      this.addDismissActionToButton(alert);
    });
  });
};

Alert.addEventListeners();
