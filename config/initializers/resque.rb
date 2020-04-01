Rails.env.production? do
  Resque.redis = $redis
end
