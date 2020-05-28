const Alert = {};

Alert.getHeader = function() {
  return document.querySelector('#alert-insertion');
};

Alert.getAlert = function(id) {
  return document.querySelector(`#${id}`);
};

Alert.getAlerts = function() {
  return document.querySelectorAll('.alert');
};

Alert.render = function(alert) {
  this.getHeader().insertAdjacentHTML('afterend', alert);
  const newAlert = this.getHeader().nextElementSibling;
  this.autoDismiss(newAlert.id);
  this.addDismissActionToButton(newAlert);
  this.setWindowScrollingEvent(newAlert.id, this.getAlertTop(newAlert.id));
};

Alert.dismiss = function(id) {
  const alert = this.getAlert(id);
  if (alert) {
    AnimateCSS.animate(alert, 'fadeOut', () => {
      alert.parentNode.removeChild(alert);
    });
  }
};

Alert.autoDismiss = function(id) {
  setTimeout(() => {
    this.dismiss(id);
  }, 10000);
};

Alert.addDismissActionToButton = function(alert) {
  alert.lastElementChild.addEventListener('click', () => {
    this.dismiss(alert.id)
  });
};

Alert.getAlertTop = function(id) {
  return this.getAlert(id).offsetTop;
};

Alert.setWindowScrollingEvent = function(alertId, alertTop) {
  window.addEventListener('scroll', () =>{
    if (this.getAlert(alertId)) {
      if (window.scrollY >= alertTop) {
        this.getAlert(alertId).style = 'position: fixed; top: 0; right: 0; left: 0; margin: 0';
      } else {
        this.getAlert(alertId).style = '';
      }
    }
  });
};

Alert.addEventListeners = function() {
  document.addEventListener('turbolinks:load', () => {
    this.getAlerts().forEach(alert => {
      this.autoDismiss(alert.id);
      this.addDismissActionToButton(alert);
      this.setWindowScrollingEvent(alert.id, this.getAlertTop(alert.id));
    });
  });
};

Alert.addEventListeners();
