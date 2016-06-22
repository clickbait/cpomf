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
end
