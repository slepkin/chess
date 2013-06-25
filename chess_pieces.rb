class ChessPiece
  attr_reader :color, :position


  def initialize(position,color,board)
    @position = position
    @color = color
    @board = board
  end

  def move!(endpoint)
    @position = endpoint if valid_move?(endpoint)
  end
  #The below methods don't work with knights
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