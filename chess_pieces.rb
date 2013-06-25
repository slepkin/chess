class ChessPiece
  attr_reader :color, :position


  def initialize(position,color,board)
    @position = position
    @color = color
    @board = board
  end

  def move(endpoint)
    @position = endpoint if valid_move?(endpoint)
  end

  def valid_move?(endpoint)
    true
  end
end

class Queen < ChessPiece
  STEPS = (-1..1).flat_map do |i|
    (-1..1).map{|j| [i,j]}
  end - [[0,0]]

  def valid_move?(endpoint)
    y1, x1 = @position

    STEPS.any? do |step|
      dy, dx = step
      (1...8).any? do |step_size| #if you want start to be in range, add 0
        [y1 + step_size * dy, x1 + step_size * dx] == endpoint
      end
    end
  end
end

class Rook < ChessPiece
  STEPS = [[1,0],[0,1],[-1,0],[0,-1]]

  def valid_move?(endpoint)
    y1, x1 = @position

    STEPS.any? do |step|
      dy, dx = step
      (1...8).any? do |step_size| #if you want start to be in range, add 0
        [y1 + step_size * dy, x1 + step_size * dx] == endpoint
      end
    end
  end
end

class Bishop < ChessPiece
  STEPS = [[1,1],[-1,1],[-1,1],[1,-1]]

  def valid_move?(endpoint)
    y1, x1 = @position

    STEPS.any? do |step|
      dy, dx = step
      (1...8).any? do |step_size| #if you want start to be in range, add 0
        [y1 + step_size * dy, x1 + step_size * dx] == endpoint
      end
    end
  end
end

class King < ChessPiece
  STEPS = (-1..1).flat_map do |i|
    (-1..1).map{|j| [i,j]}
  end - [[0,0]]

  def valid_move?(endpoint)
    y1, x1 = @position

    STEPS.any? do |step|
      dy, dx = step
      [y1 + dy, x1 + dx] == endpoint
    end
  end
end

class Knight < ChessPiece
  STEPS = [[2, 1], [2, -1], [-2, -1], [-2, 1], [1, 2], [1, -2], [-1, 2], [-1, -2]]

  def valid_move?(endpoint)
    y1, x1 = @position

    STEPS.any? do |step|
      dy, dx = step
      [y1 + dy, x1 + dx] == endpoint
    end
  end
end

class Pawn < ChessPiece


  def initialize(position,color,board)
    super(position,color,board)
    @sign = @color == :black ? 1 : -1
    @start_row = @color == :black ? 1 : 6
  end


  def valid_move?(endpoint)
    y1, x1 = @position
    @board.display_board

    y2, x2 = endpoint
    dy, dx = y2 - y1, x2 - x1
    end_object = @board.what_is_at(endpoint)
    case [dy, dx]
    when [@sign, 0]
      end_object.nil?
    when [2 * @sign, 0]
      @position[0] == @start_row && end_object.nil?
    when [@sign, 1], [@sign, -1]
      end_object && end_object.color != color
    else
      false
    end
  end
end
