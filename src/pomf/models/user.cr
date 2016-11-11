module Pomf::Models
  class User
    getter id : Int32
    property username : String
    getter password : Crypto::Bcrypt::Password
    property email : String
    property access_token : String

    def self.new(username, password, email)
      new(-1, username, Crypto::Bcrypt::Password.create(password, cost: Pomf.bcrypt_cost), email, SecureRandom.hex(32))
    end

    def self.new(id, username, password_bcrypt : String, email, access_token)
      new(id, username, Crypto::Bcrypt::Password.new(password_bcrypt), email, access_token)
    end

    def self.where(query : String, params = [] of Nil)
      Pomf.db.connection do |db|
        query = "SELECT id, username, password_bcrypt, email, access_token FROM users WHERE #{query} LIMIT 1"
        row = db.exec({Int32, String, String, String, String}, query, params).rows.first
        User.new(*row)
      end
    end

    def self.where_multi(query : String, params = [] of Nil)
      Pomf.db.connection do |db|
        query = "SELECT id, username, password_bcrypt, email, access_token FROM users WHERE #{query} ORDER BY username ASC"
        rows = db.exec({Int32, String, String, String, String}, query, params).rows
        rows.map { |row| User.new(*row) }
      end
    end

    def initialize(@id, @username, @password, @email, @access_token)
    end

    def password=(password_raw : String)
      @password = Crypto::Bcrypt::Password.create(password_raw, cost: Pomf.bcrypt_cost)
    end

    def save
      raise "Record has not been created" if @id == -1

      Pomf.db.connection do |db|
        db.exec("UPDATE users SET (username, password_bcrypt, email, access_token) = ($1, $2, $3, $5) WHERE id = $4", [
          @username, @password.to_s, @email, @id, @access_token,
        ])
      end

      self
    end

    def create!
      raise "Record already created" unless @id == -1

      Pomf.db.connection do |db|
        result = db.exec({Int32}, "INSERT INTO users (username, password_bcrypt, email, access_token) VALUES ($1, $2, $3, $4) RETURNING id", [
          @username, @password.to_s, @email, @access_token,
        ])

        @id = result.rows.first[0]
      end

      self
    end
  end
end
