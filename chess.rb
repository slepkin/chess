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
        if @board.legal_move?(*move, :white)
          @board.move_and_kill(*move)
        end #Have player repeat move
      elsif
        player_turn == :black
        move = @black_player.make_move
        if @board.legal_move?(*move, :black)
          @board.move_and_kill(*move)
        end #Have player repeat move
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

