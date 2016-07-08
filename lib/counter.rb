class Counter
  attr_reader :start, :display_on
  attr_accessor :counter

  def initialize value, display_on: 100_000
    @start = @counter = Integer(value) # intentionally throw an exception if this isn't an integer value
    @display_on = display_on
  end

  def add value
    @counter = @counter + value.to_i
    if @counter + 1 % display_on == 0
      puts '.'
    end
    self
  end
  alias_method :+, :add

  def self.with_count start = 0
    yield(cnt = new(start))
    cnt.counter
  end
  
end
