class String
  def lchomp(char : Char)
    if starts_with?(char)
      String.new(unsafe_byte_slice(char.bytesize))
    else
      self
    end
  end

  def trim(char : Char)
    lchomp(char).chomp(char)
  end

  def to_slug
    slug = self.downcase.gsub(/[^A-Za-z1-9]+/, '-').trim('-')

    slug.empty? ? "-" : slug
  end

  # Monkeypatch to fix https://github.com/crystal-lang/crystal/issues/3513
  # FIXME: remove after 0.20.0

  def rindex(search : Char, offset = size - 1)
    # If it's ASCII we can delegate to slice
    if search.ascii? && ascii_only?
      return to_slice.rindex(search.ord.to_u8, offset)
    end

    offset += size if offset < 0
    return nil if offset < 0

    last_index = nil

    each_char_with_index do |char, i|
      if i <= offset && char == search
        last_index = i
      end
    end

    last_index
  end

  def index(search : Char, offset = 0)
    # If it's ASCII we can delegate to slice
    if search.ascii? && ascii_only?
      return to_slice.index(search.ord.to_u8, offset)
    end

    offset += size if offset < 0
    return nil if offset < 0

    each_char_with_index do |char, i|
      if i >= offset && char == search
        return i
      end
    end

    nil
  end
end
