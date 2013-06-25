class ChessPiece
  attr_reader :color, :position
  STEPS = (-1..1).flat_map do |i|
    (-1..1).map{|j| [i,j]}
  end - [[0,0]]

  def initialize(position,color,board)
    @position = position
    @color = color
    @board = board
  end

  #The below methods don't work with knights
  def valid_move?(endpoint)
    valid_endpoint?(endpoint) && empty_path?(endpoint) && in_range?(endpoint)
  end

  def in_range? #Restricted by subclasses
    true
  end

  def valid_endpoint?(endpoint)
    endpoint_piece = @board.what_is_at(endpoint)
    #board needs a method that takes position and returns piece there
    endpoint_piece.nil? || endpoint_piece.color != @color
  end

  def empty_path?(endpoint)
    path = path(endpoint)
    path.all?{|pos| @board.what_is_at(pos).nil?}
  end

  def path(endpoint)
    path = []
    y1, x1 = @position
    y2, x2 = endpoint
    step = [y2 - y1, x2 - x1]
    magnitude = step.find {|substep| substep != 0}.abs

    step.map!{ |substep| substep / magnitude}
    (magnitude - 1).times do |step_size|
      path << [y1 + (step_size + 1) * step[0], x1 + (step_size + 1) * step[1]]
    end

    path
  end

end

class Queen < ChessPiece
  def in_range?(endpoint)
    y1, x1 = @position

    STEPS.any? do |step|
      dy, dx = step
      (1...8).any? do |step_size| #if you want start to be in range, add 0
        [y1 + step_size * dy, x1 + step_size * dx] == endpoint
      end
    end
  end
end

class Board
  def initialize
    spawn_pieces!
  end

  def spawn_pieces!
    @pieces = []
    8.times {|i| @pieces << Queen.new([7,i], :white, self)}
    8.times {|i| @pieces << Queen.new([0,i], :black, self)}
  end

  def what_is_at(pos)
    @pieces.find do |piece|
      piece.position == pos
    end
  end


end