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
    player_turn = :black
    puts "Welcome to chess!"

    until @board.game_ended_by?(player_turn)
      player_turn = toggle_color(player_turn)

      if player_turn == :white
        turn_of(@white_player)
      else
        turn_of(@black_player)
      end
    end

    game_over(player_turn)
  end


  private

  def toggle_color(color)
    (color == :white) ? :black : :white
  end

  def game_over(winning_color)
    @board.display_board
    losing_color = toggle_color(winning_color)
    if @board.in_check?(losing_color)
      puts "Checkmate! #{winning_color.to_s.capitalize} Wins!"
    else
      puts "Stalemate."
    end
  end

  def turn_of(player)
    color = player.color
    @board.display_board
    puts "Check" if @board.in_check?(color)
    puts "#{color.to_s.upcase} TURN"

    begin
      move = player.make_move
      valid_input_check(move, color)
      @board.move_and_kill(*move)
    rescue MoveError => e
      puts e.message
      puts "Please try again."
      @board.display_board
      retry
    end
  end

  def valid_input_check(move, color)
    if @board.what_is_at(move[0]).nil?
      raise MoveError.new "There's no piece there."
    end
    unless color == @board.what_is_at(move[0]).color
      raise MoveError.new "That's not your piece."
    end
    unless @board.legal_move?(*move, color)
      raise MoveError.new "Illegal move."
    end
    if @board.causes_check?(*move, color)
      raise MoveError.new "This will put you in check."
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
    if str.chomp == "quit" || str.chomp == "exit"
      abort('Thanks for playing!')
    end
    chars = str.split(//)
    [chars[1].to_i-1, chars[0].ord - 97]
  end
end

class MoveError < RuntimeError
end

game = Game.new
game.play

