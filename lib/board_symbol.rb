class BoardSymbol
  attr_reader :letter

  def initialize(letter)
    @letter = letter
  end

  def to_s
    @letter
  end
end
