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
end
