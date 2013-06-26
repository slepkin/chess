# encoding: UTF-8
require './chessboard.rb'
require './chess_pieces.rb'
require 'debugger'

class Game
  def initialize
    @board = Board.new
    @white_player = HumanPlayer.new(:white)
    @black_player = HumanPlayer.new(:black)
  end


  def play
    player_turn = :white
    puts "Welcome to chess!"

    until @board.in_checkmate?(player_turn)
      puts "#{player_turn.to_s.upcase} TURN"
      @board.display_board

      if player_turn == :white
        turn_of(@white_player)
      else
        turn_of(@black_player)
      end

      player_turn = (player_turn == :white) ? :black :  :white
      puts "Check" if @board.in_check?(player_turn)
    end

    @board.display_board

    puts "#{player_turn.to_s.upcase} LOSES!!!!"

  end

  def turn_of(player)
    color = player.color
    begin
      move = player.make_move
      if @board.what_is_at(move[0]).nil?
        raise ArgumentError.new "There's no piece there"
      end
      unless color == @board.what_is_at(move[0]).color
        raise ArgumentError.new "That's not your piece."
      end
      unless @board.legal_move?(*move, color)
        raise ArgumentError.new "Illegal move."
      end
      if @board.causes_check?(*move, color)
        raise ArgumentError.new "This will put you in check."
      end
      @board.move_and_kill(*move)
    rescue ArgumentError => e
      puts e.message
      puts "try again"
      @board.display_board
      retry
    end
  end



end

class HumanPlayer
  attr_reader :color

  def initialize(color)
    @color = color
  end

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

