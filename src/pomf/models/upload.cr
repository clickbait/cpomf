module Pomf::Models
  class Upload
    getter id : Int32
    getter user_id : Int32?
    property filename : String
    property hash : String?
    getter original_filename : String?
    getter size : Int64
    getter created : Time

    def self.new(filename, size, hash, original_filename = nil, user_id : Int? = nil)
      new(-1, user_id, filename, original_filename, size, hash, Time.now)
    end

    def self.new(id, user_id, filename, size, hash, created, original_filename = nil)
      new(id, user_id, filename, original_filename, size, hash, created)
    end

    def self.new(filename, size, hash, original_filename = nil, user : User? = nil)
      new(filename, size, hash, original_filename, user.try &.id)
    end

    def self.where(query : String, params = [] of Nil)
      Pomf.db.connection do |db|
        query = "SELECT id, user_id, filename, original_filename, size, hash, created FROM uploads WHERE #{query} LIMIT 1"
        rows = db.exec({Int32, Int32 | Nil, String, String | Nil, Int64, String | Nil, Time}, query, params).rows

        !rows.empty? ? Upload.new(*rows.first) : nil
      end
    end

    def self.where_multi(query : String, params = [] of Nil)
      Pomf.db.connection do |db|
        query = "SELECT id, user_id, filename, original_filename, size, hash, created FROM uploads WHERE #{query}"
        rows = db.exec({Int32, Int32 | Nil, String, String | Nil, Int64, String | Nil, Time}, query, params).rows
        rows.map { |row| Upload.new(*row) }
      end
    end

    def initialize(@id, @user_id, @filename, @original_filename, @size, @hash, @created)
    end

    def save
      raise "Record has not been created" if @id == -1

      Pomf.db.connection do |db|
        db.exec("UPDATE uploads SET (user_id, filename, original_filename, size, hash, created) = ($1, $2, $3, $4, $5, $6) WHERE id = $6", [
          @user_id, @filename, @original_filename, @size, @hash, @created, @id,
        ])
      end

      self
    end

    def create!
      raise "Record already created" unless @id == -1

      Pomf.db.connection do |db|
        result = db.exec({Int32}, "INSERT INTO uploads (user_id, filename, original_filename, size, hash, created) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id", [
          @user_id, @filename, @original_filename, @size, @hash, @created,
        ])

        @id = result.rows.first[0]
      end

      self
    end
  end
end
