const DateHelper = {};

DateHelper.time_ago_in_words_with_parsing = function(from) {
  // Takes the format of "Jan 15, 2007 15:45:00 GMT" and converts it to a relative time
  // Ruby strftime: %b %d, %Y %H:%M:%S GMT
  const date = new Date;
  date.setTime(Date.parse(from));
  return this.time_ago_in_words(date);
};

DateHelper.time_ago_in_words = function(from) {
  // Takes a timestamp and converts it to a relative time
  // DateHelper.time_ago_in_words(1331079503000)
  return this.distance_of_time_in_words(new Date, from);
};

DateHelper.distance_of_time_in_words = function(to, from) {
  const dt = 'datetime.distance_in_words';
  const distance_in_seconds = ((to - from) / 1000);
  const distance_in_minutes = Math.abs(Math.floor(distance_in_seconds / 60));
  // const tense = distance_in_seconds < 0 ? " from now" : " ago";
  if (distance_in_minutes == 0) { return I18n.t(`${dt}.less_than_x_minutes.one`) }
  if (distance_in_minutes == 1) { return I18n.t(`${dt}.x_minutes.one`) }
  if (distance_in_minutes < 45) { return I18n.t(`${dt}.x_minutes.other`, { count: distance_in_minutes }) }
  if (distance_in_minutes < 90) { return I18n.t(`${dt}.about_x_hours.one`) }
  if (distance_in_minutes < 1440) { return I18n.t(`${dt}.about_x_hours.other`, { count: Math.floor(distance_in_minutes / 60) }) }
  if (distance_in_minutes < 2880) { return I18n.t(`${dt}.x_days.one`) }
  if (distance_in_minutes < 43200) { return I18n.t(`${dt}.x_days.other`, { count: Math.floor(distance_in_minutes / 1440) }) }
  if (distance_in_minutes < 86400) { return I18n.t(`${dt}.about_x_months.one`) }
  if (distance_in_minutes < 525960) { return I18n.t(`${dt}.about_x_months.other`, { count: Math.floor(distance_in_minutes / 43200) }) }
  if (distance_in_minutes < 1051199) { return I18n.t(`${dt}.about_x_years.one`) }

  return I18n.t(`${dt}.over_x_years.other`, { count: Math.floor(distance_in_minutes / 525960) });
};
