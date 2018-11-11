require_relative 'node'

class Table
  attr_accessor :width, :height

  def initialize(table)
    @width  = table.first.size
    @height = table.size
    @table = table

    @table = @table.map.with_index do |row, y|
      row.map.with_index do |value, x|
        Node.new(value, x, y)
      end
    end
  end

  def [](x, y)
    @table[y][x]
  end

  def visit(start_x: 0, start_y: 0, end_x: -1, end_y: -1)
    current = self[start_x, start_y]
    current.distance = 0
    looking_set = SortedSet.new
    looking_set << current
    # return current if start_x == end_x && start_y == end_y

    while current
      looking_set.delete(current)
      adjacency = current.adjacency(width, height).map { |x, y| self[x, y] }.reject { |node| node.zero? || node.visited? }
      current.visit
      adjacency.each do |node|
        distance = current.distance + node.value
        if node.distance > distance
          node.distance = distance
          node.previous = current
        end
        current.neighborhood << node
        looking_set << node
      end
      current = looking_set.first
    end

  end

  def to_s
    @table.map { |row| row.map(&:to_str).join(" ")}.join("\n")
  end
end

table = [
    [1, 0, 2, 3, 2, 3, 2, 3, 2, 3, 1],
    [3, 2, 1, 2, 3, 3, 1, 2, 3, 2, 1],
    [4, 3, 2, 1, 2, 3, 4, 5, 0, 3, 1],
    [1, 6, 2, 3, 2, 3, 2, 3, 2, 3, 1],
    [3, 2, 1, 2, 3, 0, 1, 2, 3, 2, 1],
    [4, 3, 2, 1, 2, 3, 4, 5, 3, 3, 1],
    [1, 2, 0, 3, 2, 3, 2, 3, 2, 3, 1],
    [3, 2, 1, 2, 3, 3, 1, 2, 3, 2, 1],
    [4, 3, 2, 1, 2, 3, 4, 5, 3, 0, 1],
    [1, 7, 2, 3, 2, 3, 2, 3, 2, 3, 1]
]

t = Table.new(table)
puts t
puts "visiting nodes..."
t.visit(end_x: 7, end_y: 9)
puts t
puts "all nodes visited"
target = t[9, 7]
puts target.distance
puts target.path_size
path = target.path
path.each do |step|
  puts step.inspect
end
