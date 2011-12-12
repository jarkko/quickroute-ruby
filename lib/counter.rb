class Counter
  include Comparable

  def initialize(num = 0)
    @num = num
  end

  def inc(amt = 1)
    @num += amt
  end

  def to_i
    @num
  end

  def coerce(something)
    case something
    when Numeric
      return to_i, self
    else
      raise TypeError, "#{self.class} can't be coerced into #{other.class}"
    end
  end

  def +(other)
    @num.+(other)
  end

  def <=>(other)
    @num.<=>(other)
  end
end
