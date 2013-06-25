require 'set'

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

class Board
  SIZE = 8
  def initialize
    spawn_pieces!
  end

  def spawn_pieces!
    @pieces = Set.new
    @pieces << Queen.new([7,3], :white, self)
    @pieces << Queen.new([0,3], :black, self)
    @pieces << King.new([7,4], :white, self)
    @pieces << King.new([0,4], :black, self)
    @pieces << Bishop.new([7,2], :white, self)
    @pieces << Bishop.new([7,5], :white, self)
    @pieces << Bishop.new([0,2], :black, self)
    @pieces << Bishop.new([0,5], :black, self)
    @pieces << Rook.new([7,0], :white, self)
    @pieces << Rook.new([7,7], :white, self)
    @pieces << Rook.new([0,0], :black, self)
    @pieces << Rook.new([0,7], :black, self)
    @pieces << Knight.new([7,1], :white, self)
    @pieces << Knight.new([7,6], :white, self)
    @pieces << Knight.new([0,1], :black, self)
    @pieces << Knight.new([0,6], :black, self)

  end

  def move_from_to(startpoint, endpoint)
    piece = what_is_at(startpoint)
    if empty_or_opposite_color?(piece.color, endpoint) && \
      (piece.is_a?(Knight) || empty_path?(startpoint,endpoint))
      kill!(endpoint) if opposite_color?(piece.color,endpoint)
      piece.move!(endpoint)
    end
  end

  def what_is_at(pos)
    @pieces.find do |piece|
      piece.position == pos
    end
  end

  def display_board
    display = (0...SIZE).map do |i|
      (0...SIZE).map do |j|
        convert_to_unicode(what_is_at([i,j]))
      end
    end

    display.each do |row|
      puts row.join("  ")
    end
    nil
  end

  private

  def coord_on_board?(coord)
    y, x = coord
    y.between?(0, SIZE - 1) && x.between?(0, SIZE - 1)
  end

  def opposite_color?(color, endcoord)
    other_piece = what_is_at(endcoord)
    other_piece && color != other_piece.color
  end

  def kill!(coord)
    @pieces.delete(what_is_at(coord))
  end

  def empty_or_opposite_color?(color, endpoint)
    endpoint_piece = what_is_at(endpoint)
    endpoint_piece.nil? || endpoint_piece.color != color
  end

  def empty_path?(startpoint, endpoint)
    path = path(startpoint, endpoint)
    path.all?{|pos| what_is_at(pos).nil?}
  end

  def path(startpoint, endpoint)
    path = []
    y1, x1 = startpoint
    y2, x2 = endpoint
    step = [y2 - y1, x2 - x1]
    unless step.include?(0) || step[0].abs == step[1].abs
      raise ArgumentError.new "Path must call horiz, vert, or diagonal line"
    end
    magnitude = step.find {|substep| substep != 0}.abs

    step.map!{ |substep| substep / magnitude}
    (magnitude - 1).times do |step_size|
      path << [y1 + (step_size + 1) * step[0], x1 + (step_size + 1) * step[1]]
    end

    path
  end

  def convert_to_unicode(piece)
    color = piece ? piece.color : nil
    case [piece.class, color]
    when [Queen, :white]
      "Q"# "♕"
    when [Queen, :black]
      "q"#  "♛"
    when [Rook, :white]
      "R"# "♕"
    when [Rook, :black]
      "r"#  "♛"
    when [Bishop, :white]
      "B"# "♕"
    when [Bishop, :black]
      "b"#  "♛"
    when [King, :white]
      "K"# "♕"
    when [King, :black]
      "k"#  "♛"
    when [Knight, :white]
      "N"# "♕"
    when [Knight, :black]
      "n"#  "♛"
    when [NilClass, nil]
      "_"# "□"
    end
  end

end