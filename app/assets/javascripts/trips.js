const Trip = {};

Trip.removeFromPage = function(tripId, message='You did not created any trip yet.') {
  Card.remove(`trip-id-${tripId}`, message);
};
