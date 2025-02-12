class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform
    redis = Redis.new
    redis.keys("cart:*").each do |key|
      last_activity = redis.get(key)
      if last_activity && Time.now - Time.parse(last_activity) > 3.hours
        redis.set("#{key}:abandoned", true)
      end
    end

    redis.keys("cart:*:abandoned").each do |key|
      if Time.now - Time.parse(redis.get(key)) > 7.days
        redis.del(key)
        redis.del(key.gsub(':abandoned', ''))
      end
    end
  end
end