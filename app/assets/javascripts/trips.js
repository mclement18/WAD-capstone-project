const Trip = {};

Trip.removeFromPage = function(tripId) {
  Card.remove(`trip-id-${tripId}`);
};
