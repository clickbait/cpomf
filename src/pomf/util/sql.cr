module Pomf::Util
  class PGSpy < PG::Connection
    def exec(types, query : String, params) : PG::Result
      time_start = Time.now
      res = super
      time_end = Time.now

      puts "PG (#{(time_end - time_start).total_milliseconds}ms): #{query.inspect} << #{params.inspect}"
      res
    end

    def exec(types, query : String, params) : Nil
      time_start = Time.now
      super { |row, fields| yield row, fields }
      time_end = Time.now

      puts "PG (#{(time_end - time_start).total_milliseconds}ms): #{query.inspect} << #{params.inspect}"
    end
  end

  def self.transaction
    # TODO: support nested transactions
    Lewd.db.connection do |db|
      begin
        db.exec("BEGIN")
        yield db
        db.exec("COMMIT")
      rescue e
        db.exec("ROLLBACK")
        raise e
      end
    end
  end
end
