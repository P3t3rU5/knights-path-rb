require 'set'

class Node
  attr_accessor :value, :x, :y, :visited, :neighborhood, :distance, :previous

  def initialize(value, x, y)
    @value = value
    @zero = value.zero?
    @x = x
    @y = y
    @neighborhood = SortedSet.new
    @distance = Float::INFINITY
    @previous = nil
  end

  def visited?
    @visited
  end

  def zero?
    @zero
  end

  def ==(other)
    return unless other
    other.is_a?(self.class) && other.value == @value && other.x == @x && other.y == @y
  end

  def <=>(other)
    @distance <=> other.distance
  end

  def adjacency(width, height)
    [
        [@x + 1, @y - 2], [@x + 2, @y - 1], [@x + 2, @y + 1], [@x + 1, @y + 2], [@x - 1, @y + 2], [@x - 2, @y + 1],
        [@x - 2, @y - 1], [@x - 1, @y - 2]
    ].select { |pair| pair.first.between?(0, width - 1) && pair.last.between?(0, height - 1) }
  end

  def visit
    @visited = true
  end

  def to_s
    "<Node@(#{@x}, #{@y}), distance: #{@distance}, previous: #{@previous&.to_str})>"
  end

  def to_str
    case
      when visited? then "V"
      when zero? then "*"
      else @value.to_s
    end
  end

  def inspect
    "<Node@(#{@x}, #{@y}), distance: #{@distance}, previous: #{@previous&.to_str})>"
  end

  def path
    return @path if @path
    previous = @previous
    @path = [self]
    loop do
      path << previous
      previous = previous.previous
      break unless previous
    end
    @path
  end

  def path_cost
    path.map(&:value).reduce(&:+) - path.last.value
  end

  def path_size
    path.size
  end
end