# encoding: UTF-8
require 'set'
require './chess_pieces.rb'

class Board
  attr_accessor :pieces

  SIZE = 8
  def initialize
    spawn_pieces
  end

  def spawn_pieces
    spawn_backrows
    spawn_pawns
  end

  def spawn_backrows
    piece_types = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    @pieces = Set.new
    piece_types.each_with_index do |type,i|
      @pieces << type.new([7, i], :black,self)
      @pieces << type.new([0, i], :white,self)
    end
  end

  def spawn_pawns
    SIZE.times { |i| @pieces << Pawn.new([1,i], :white,self)}
    SIZE.times { |i| @pieces << Pawn.new([6,i], :black,self)}
  end

  def legal_move?(startpoint, endpoint, color)
    piece = what_is_at(startpoint)
    end_piece = what_is_at(endpoint)
    empty_or_opposite_color?(color, endpoint) && \
      (piece.is_a?(Knight) || empty_path?(startpoint,endpoint)) &&\
      piece.in_range?(endpoint)#&& !causes_check?(startpoint, endpoint, color)
  end

  def move_and_kill(startpoint, endpoint)
    kill(what_is_at(endpoint))
    what_is_at(startpoint).move(endpoint)
  end

  def what_is_at(pos)
    @pieces.find do |piece|
      piece.position == pos
    end
  end

  def display_board
    display = (0...SIZE).map do |i|
      (0...SIZE).map do |j|
        object_there = what_is_at([i , j])
        object_there ? object_there.to_s : " "
      end
    end
    #Yeah, I know it's a mess. Feel free to do better:
    print "   "
    ("a".."h").each{|letter| print " #{letter}  "}
    puts "\n  ┌"+ "───┬" * 7 + "───┐"
    display.each_with_index do |row,i|
      puts "#{i+1} │ " + row.join(" │ ") + " │"
      puts "  ├" + "───┼" * 7 + "───┤" unless i == 7
    end
    puts "  └"+ "───┴" * 7 + "───┘"
    nil
  end

  def in_checkmate?(king_color)
    in_check?(king_color) && every_move_causes_check(king_color)
  end

  def dup
    new_board = Board.new
    new_board.pieces = Set.new(@pieces.map{|piece| piece.dup})
    new_board
  end

  def coord_on_board?(coord)
    y, x = coord
    y.between?(0, SIZE - 1) && x.between?(0, SIZE - 1)
  end

  def kill(piece)
    @pieces.delete(piece)
  end

  def empty_or_opposite_color?(color, endpoint)
    endpoint_piece = what_is_at(endpoint)
    endpoint_piece.nil? || endpoint_piece.color != color
  end

  def empty_path?(startpoint, endpoint)
    begin
      path = path(startpoint, endpoint)
    rescue ArgumentError => e
      #puts e.message
      return false
    end
      path.all?{|pos| what_is_at(pos).nil?}
  end

  def path(startpoint, endpoint)
    path = []
    y1, x1 = startpoint
    y2, x2 = endpoint
    step = [y2 - y1, x2 - x1]

    unless step.include?(0) || step[0].abs == step[1].abs
      #p "Argument raised"
      raise ArgumentError.new "Path must call horiz, vert, or diagonal line"
    end

    magnitude = step.find {|substep| substep != 0}.abs

    step.map!{ |substep| substep / magnitude}
    (magnitude - 1).times do |step_size|
      path << [y1 + (step_size + 1) * step[0], x1 + (step_size + 1) * step[1]]
    end

    path
  end

  def in_check?(king_color)
    king = @pieces.find{ |piece| piece.color == king_color && piece.class == King}
    k_pos = king.position
    other_color = king_color == :black ? :white : :black

    @pieces.select{ |piece| piece.color == other_color}.any? do |piece|
      legal_move?(piece.position, k_pos, other_color)
    end
  end

  def causes_check?(startpoint, endpoint, color) #only called if valid_move
    temp_board = self.dup
    temp_piece = temp_board.what_is_at(startpoint)

    temp_board.move_and_kill(startpoint, endpoint)
    temp_board.in_check?(color)
  end

  def every_move_causes_check?(king_color)
    @pieces.select {|piece| piece.color == king_color }.all? do |piece|
      piece.possible_moves.all? do |possible_move|
        causes_check?(piece.position, possible_move, king_color)
      end
    end
  end

  def only_kings?
    @pieces.size == 2
  end

  # will allow for future additional ending conditions
  def game_ended_by?(last_color)
    next_color = (last_color == :white) ? :black : :white
    every_move_causes_check?(next_color) || only_kings?
    # add other types of stalemate
  end
end