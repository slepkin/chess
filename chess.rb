# encoding: UTF-8
require './chessboard.rb'
require './chess_pieces.rb'
require 'debugger'

class Game
  def initialize
    @board = Board.new
    @white_player = HumanPlayer.new
    @black_player = HumanPlayer.new
  end


  def play
    player_turn = :white
    until @board.in_checkmate?(player_turn)
      puts "Welcome to chess!"
      @board.display_board

      if player_turn == :white
        move = @white_player.make_move
        @board.move_piece(*move, :white)
      elsif
        player_turn == :black
        move = @black_player.make_move
        @board.move_piece(*move, :black)
      end

      player_turn = (player_turn == :white) ? :black :  :white
    end
  end



end

class HumanPlayer

  def make_move
    gets.chomp.split(",").map{|str| parse(str)}
  end

  private

  def parse(str)
    chars = str.split(//)
    [chars[1].to_i-1,chars[0].ord - 97]
  end


end

game = Game.new
game.play



#
#
#
#
#
# board = Board.new
# board.move_piece(parse("e2"),parse("e4"))
# board.display_board
# puts
# board.move_piece(parse("d1"),parse("h5"))
# board.display_board
# puts
# board.move_piece(parse("f1"),parse("c4"))
# board.display_board
# puts
# board.move_piece(parse("h5"),parse("f7"))
# board.display_board
# puts
#
# puts board.in_checkmate?(:white)
# puts board.in_checkmate?(:black)
#
# # p board.move_piece([6,0], [4,0])
# # puts
# # puts
# # p board.move_piece([7,0],[8,0])
# # board.move_piece([6,0], [4,0])
# # board.display_board
# # board.move_piece([4,0], [3,0])
# # board.display_board
# # board.move_piece([3,0], [2,0])
# # board.display_board
# # board.move_piece([2,0], [1,1])
# # board.display_board
# # board.move_piece([1,1], [2,1])
