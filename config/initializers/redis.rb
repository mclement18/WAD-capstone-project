Rails.env.production? do
  $redis = Redis.new(url: ENV["REDIS_URL"])
end
