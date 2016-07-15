module Pomf::Models
  class Page
    getter id : Int32
    property title : String
    property slug : String
    property content : String?

    def self.new(title, content)
      new(-1, title, title.to_slug, content)
    end

    def self.new(id, title, slug, content)
      new(id, title, slug, content)
    end

    def self.where(query : String, params = [] of Nil)
      Pomf.db.connection do |db|
        query = "SELECT id, title, slug, content FROM pages WHERE #{query} LIMIT 1"
        row = db.exec({Int32, String, String, String}, query, params).rows.first
        Page.new(*row)
      end
    end

    def self.where_multi(query : String, params = [] of Nil)
      Pomf.db.connection do |db|
        query = "SELECT id, title, slug, content FROM pages WHERE #{query} ORDER BY title ASC"
        rows = db.exec({Int32, String, String, String | Nil}, query, params).rows
        rows.map { |row| Page.new(*row) }
      end
    end

    def initialize(@id, @title, @slug, @content)
    end

    def save
      raise "Record has not been created" if @id == -1

      Pomf.db.connection do |db|
        db.exec("UPDATE pages SET (title, slug, content) = ($1, $2, $3) WHERE id = $4", [
          @title, @slug, @content, @id,
        ])
      end

      self
    end

    def create!
      raise "Record already created" unless @id == -1

      Pomf.db.connection do |db|
        result = db.exec({Int32}, "INSERT INTO pages (title, slug, content) VALUES ($1, $2, $3) RETURNING id", [
          @title, @slug, @content,
        ])

        @id = result.rows.first[0]
      end

      self
    end
  end
end
