module Pomf::Util
  def self.cache(key : String)
    Pomf.redis.connection do |redis|
      val = redis.get(key)
      return val if val

      val = yield
      redis.set(key, val)

      val
    end
  end
end
