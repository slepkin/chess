# encoding: UTF-8
require 'set'
require './chess_pieces.rb'

class Board
  attr_accessor :pieces

  def initialize
    spawn_pieces
  end

  def legal_move?(startpoint, endpoint, color)
    piece = what_is_at(startpoint)
    end_piece = what_is_at(endpoint)

    empty_or_opposite_color?(color, endpoint) && \
      (piece.is_a?(Knight) || empty_path?(startpoint, endpoint)) &&\
      piece.in_range?(endpoint)
  end

  def move_and_kill(startpoint, endpoint)
    moving_piece = what_is_at(startpoint)
    kill(what_is_at(endpoint))
    moving_piece.move(endpoint)
    promote(moving_piece) if moving_piece.promote?
  end

  def what_is_at(pos)
    @pieces.find do |piece|
      piece.position == pos
    end
  end

  def display_board
    display = (0...8).map do |i|
      (0...8).map do |j|
        object_there = what_is_at([i , j])
        object_there ? object_there.to_s : " "
      end
    end

    puts ("a".."h").inject("   "){ |so_far, letter| so_far + " #{letter}  "}
    puts "  ┌"+ "───┬" * 7 + "───┐"
    display.each_with_index do |row, i|
      puts "#{i+1} │ " + row.join(" │ ") + " │"
      puts "  ├" + "───┼" * 7 + "───┤" unless i == 7
    end
    puts "  └"+ "───┴" * 7 + "───┘"
    nil
  end

  def in_check?(king_color)
    king = @pieces.find{ |piece| piece.color == king_color && piece.class == King}
    k_pos = king.position
    other_color = (king_color == :black) ? :white : :black
    @pieces.select{ |piece| piece.color == other_color}.any? do |piece|
      legal_move?(piece.position, k_pos, other_color)
    end
  end

  # will allow for future additional ending conditions
  def game_ended_by?(last_color)
    next_color = (last_color == :white) ? :black : :white
    every_move_causes_check?(next_color) || only_kings?
    # add other types of stalemate
  end

  def causes_check?(startpoint, endpoint, color) #only called if valid_move
    temp_board = dup
    temp_piece = temp_board.what_is_at(startpoint)

    temp_board.move_and_kill(startpoint, endpoint)
    temp_board.in_check?(color)
  end

  private

  def spawn_pieces
    @pieces = Set.new
    spawn_backrows
    spawn_pawns
  end

  def spawn_backrows
    piece_types = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    piece_types.each_with_index do |type, i|
      @pieces << type.new([7, i], :black, self)
      @pieces << type.new([0, i], :white, self)
    end
  end

  def spawn_pawns
    8.times { |i| @pieces << Pawn.new([1, i], :white, self)}
    8.times { |i| @pieces << Pawn.new([6, i], :black, self)}
  end

  def promote(piece)
    position, color = piece.position, piece.color
    kill(piece)
    @pieces << Queen.new(position, color, self)
  end

  def in_checkmate?(king_color)
    in_check?(king_color) && every_move_causes_check(king_color)
  end

  def dup
    new_board = Board.new
    new_board.pieces = Set.new(@pieces.map{ |piece| piece.dup})
    new_board
  end

  def coord_on_board?(coord)
    y, x = coord
    y.between?(0, 7) && x.between?(0, 7)
  end

  def kill(piece)
    @pieces.delete(piece)
  end

  def empty_or_opposite_color?(color, endpoint)
    endpoint_piece = what_is_at(endpoint)
    endpoint_piece.nil? || endpoint_piece.color != color
  end

  def empty_path?(startpoint, endpoint)
    path = path(startpoint, endpoint)
    path.all?{ |pos| what_is_at(pos).nil?}
  end

  def path(startpoint, endpoint)
    y, x = startpoint
    step = [endpoint[0] - y, endpoint[1] - x]
    magnitude = step.max_by { |coord| coord.abs }.abs
    unit_step = divide_vector(step, magnitude)

    (1...magnitude).map do |step_number|
      [y + step_number * unit_step[0], x + step_number * unit_step[1]]
    end
  end

  def divide_vector(arr, magnitude)
    arr.map{ |coord| coord / magnitude }
  end

  def every_move_causes_check?(king_color)
    @pieces.select { |piece| piece.color == king_color }.all? do |piece|
      piece.possible_moves.all? do |possible_move|
        causes_check?(piece.position, possible_move, king_color)
      end
    end
  end

  def only_kings?
    @pieces.size == 2
  end
end