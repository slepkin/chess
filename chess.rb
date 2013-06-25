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

  def move!(endpoint)
    @position = endpoint if valid_move?(endpoint)
  end
  #The below methods don't work with knights
  def valid_move?(endpoint)
    true
  end



end

class Queen < ChessPiece
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

class Board
  SIZE = 8
  def initialize
    spawn_pieces!
  end

  def spawn_pieces!
    @pieces = []
    8.times {|i| @pieces << Queen.new([7,i], :white, self)}
    8.times {|i| @pieces << Queen.new([0,i], :black, self)}
  end

  def move_from_to(startpoint, endpoint)
    piece = what_is_at(startpoint)
    if valid_endpoint?(piece.color, endpoint) && \
      (piece.is_a?(Knight) || empty_path(startpoint,endpoint))
      piece.move!(endpoint)
    end
  end

  def what_is_at(pos)
    @pieces.find do |piece|
      piece.position == pos
    end
  end

  def coord_on_board?(coord)
    y, x = coord
    y.between?(0, SIZE - 1) && x.between?(0, SIZE - 1)
  end

  def kill? #KILLLLL

  def valid_endpoint?(color, endpoint)
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

end