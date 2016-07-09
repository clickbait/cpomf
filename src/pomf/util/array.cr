class Array
  def to_sentence
    case size
      when 0
        ""
      when 1
        self[0].to_s.dup
      when 2
        "#{self[0]} and #{self[1]}"
      else
        "#{self[0...-1].join(", ")}, and #{self[-1]}"
    end
  end
end
