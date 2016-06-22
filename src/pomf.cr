require "crouter"
require "redis"
require "http/server"
require "slang"

require "./pomf/util/**"
require "./pomf/**"

module Pomf
  def self.redis
    @@redis ||= ConnectionPool.new(capacity: 25) do
      conn = nil
      timespan = Util.timed do
        host = `getent hosts #{ENV["REDIS_HOST"]} | awk '{ printf $1 }'`
        conn = Redis.new(host, ENV["REDIS_PORT"].to_i)
      end

      puts "Connected to Redis in #{timespan.total_milliseconds}ms"
      conn.not_nil!
    end
  end

  def self.static_handler
    # dev only
    @@static_handler ||= HTTP::StaticFileHandler.new(__DIR__ + "/pomf/public/")
  end

  def self.run
    handlers = [] of HTTP::Handler

    if ENV["POMF_DEBUG"]? == "true"
      puts "Dev mode enabled"
      handlers << HTTP::ErrorHandler.new
      handlers << HTTP::LogHandler.new
    end

    handlers << Pomf::Router.new

    puts "hosting at http://0.0.0.0:#{ENV["POMF_PORT"]}/"
    HTTP::Server.new("0.0.0.0", ENV["POMF_PORT"].to_i, handlers).listen
  end
end
