$redis = Redis.new(url: ENV["REDIS_URL"]) if defined?(Redis)
