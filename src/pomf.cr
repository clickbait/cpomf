require "crouter"
require "jwt"
require "redis"
require "multipart"
require "pg"
require "pool/connection"
require "http/server"
require "crypto/bcrypt"
require "slang"
require "CrystalEmail"

require "./pomf/util/**"
require "./pomf/**"

module Pomf
  def self.db
    @@pg ||= ConnectionPool(PG::Connection).new(capacity: 25) do
      conn = nil
      timespan = Util.timed do
        conninfo = PQ::ConnInfo.from_conninfo_string(ENV["POMF_DATABASE_URL"])
        conn = if ENV["POMF_DEBUG"]? == "true" && ENV["POMF_SPEC"]? != "true"
                 Util::PGSpy.new(conninfo)
               else
                 PG::Connection.new(conninfo)
               end
      end

      puts "Connected to Postgresql in #{timespan.total_milliseconds}ms"
      conn.not_nil!
    end
  end

  def self.redis
    @@redis ||= ConnectionPool(Redis).new(capacity: 25) do
      conn = nil
      timespan = Util.timed do
        host = `getent hosts #{ENV["REDIS_HOST"]} | awk '{ printf $1 }'`
        conn = Redis.new(host, ENV["REDIS_PORT"].to_i)
      end

      puts "Connected to Redis in #{timespan.total_milliseconds}ms"
      conn.not_nil!
    end
  end

  def self.bcrypt_cost
    if ENV["POMF_DEBUG"]? == "true"
      4
    else
      14
    end
  end

  def self.static_handler
    # dev only
    @@static_handler ||= HTTP::StaticFileHandler.new(__DIR__ + "/pomf/public/")
  end

  def self.upload_dir
    @@upload_dir ||= ENV["POMF_UPLOAD_DIR"]
  end

  def self.upload_url
    @@upload_url ||= ENV["POMF_UPLOAD_URL"]
  end

  @@upload_host : String?

  def self.upload_host
    @@upload_host ||= URI.parse(upload_url).host
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
