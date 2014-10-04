class Action
  # Hold position as p
  # and symbol as s

  attr_accessor :p, :s

  def initialize(p, s)
    @p, @s = p, s
  end

  def humanized_coordinate
    [p % Board::SQRT_SIZE + 1, p / Board::SQRT_SIZE + 1]
  end

  def to_s
    "Put #{s} at #{humanized_coordinate}"
  end
end

class InitialAction
  attr_accessor :s

  def initialize(s)
    @s = s
  end
end
