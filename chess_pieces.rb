# encoding: UTF-8

class ChessPiece
  attr_accessor :position
  attr_reader :color

  def initialize(position, color, board)
    @position = position
    @color = color
    @board = board
  end

  def move(endpoint)
    @position = endpoint
  end

  def in_range?(endpoint)
    true
  end

  def possible_moves
    pos_moves = []
    (0...8).each do |y|
      (0...8).each do |x|
        pos_moves << [y , x]
      end
    end

    pos_moves.select {|move| @board.legal_move?(position, move, color)}
  end

  def promote? #Only pawns can be promoted
    false
  end

end

class Rider < ChessPiece
  def initialize(position, color, board)
    super(position, color, board)
    @steps = (-1..1).flat_map do |i|
    (-1..1).map{|j| [i, j]}
    end - [[0, 0]]
  end

  def in_range?(endpoint)
    y1, x1 = @position

    @steps.any? do |step|
      dy, dx = step
      (1...8).any? do |step_size|
        [y1 + step_size * dy, x1 + step_size * dx] == endpoint
      end
    end
  end
end

class Queen < Rider
  def initialize(position, color, board)
    super(position, color, board)
    @steps = (-1..1).flat_map do |i|
      (-1..1).map{|j| [i, j]}
    end - [[0, 0]]
  end

  def to_s
    @color == :white ? "♕" : "♛"
  end
end

class Rook < Rider
  def initialize(position, color, board)
    super(position, color, board)
    @steps = [[1, 0], [0, 1], [-1, 0], [0, -1]]
  end

  def to_s
    @color == :white ? "♖" : "♜"
  end
end

class Bishop < Rider
  def initialize(position, color, board)
    super(position, color, board)
    @steps = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
  end

  def to_s
    @color == :white ? "♗" : "♝"
  end
end

class King < ChessPiece
  STEPS = (-1..1).flat_map do |i|
    (-1..1).map{|j| [i, j]}
  end - [[0, 0]]

  def to_s
    @color == :white ? "♔" : "♚"
  end

  def in_range?(endpoint)
    y1, x1 = @position

    STEPS.any? do |step|
      dy, dx = step
      [y1 + dy, x1 + dx] == endpoint
    end
  end
end

class Knight < ChessPiece
  STEPS = [[2, 1], [2, -1], [-2, -1], [-2, 1], [1, 2], [1, -2], [-1, 2], [-1, -2]]

  def to_s
    @color == :white ? "♘" : "♞"
  end

  def in_range?(endpoint)
    y1, x1 = @position

    STEPS.any? do |step|
      dy, dx = step
      [y1 + dy, x1 + dx] == endpoint
    end
  end
end

class Pawn < ChessPiece

  def to_s
    @color == :white ? "♙" : "♟"
  end

  def in_range?(endpoint)
    y1, x1 = @position
    y2, x2 = endpoint
    dy, dx = y2 - y1, x2 - x1
    end_object = @board.what_is_at(endpoint)

    return end_object.nil? if one_forward?(dy, dx)
    return not_moved_yet? && end_object.nil? if two_forward?(dy, dx)
    return end_object && end_object.color != color if diagonal?(dy, dx)
    false
  end

  def promote?
    @position[0] == 7 - start_row + direction
  end

  private

  def direction
    (@color == :black) ? -1 : 1
  end

  def start_row
    (@color == :black) ? 6 : 1
  end

  def one_forward?(dy, dx)
    [dy, dx] == [direction, 0]
  end

  def two_forward?(dy, dx)
    [dy, dx] == [2 * direction, 0]
  end

  def diagonal?(dy, dx)
    [dy, dx.abs] == [direction, 1]
  end

  def not_moved_yet?
    @position[0] == start_row
  end


end
