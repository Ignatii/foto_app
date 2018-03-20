redis = Redis.new
redis_options = { redis_connection: redis }
IMAGE_VOTES_COUNT = Leaderboard.new('image_votes_count', Leaderboard::DEFAULT_OPTIONS, redis_options)
