# encoding: UTF-8
require './chessboard.rb'
require './chess_pieces.rb'
require 'yaml'

class Game

  attr_reader :board, :current_color

  def initialize
    @board = Board.new
    @white_player = HumanPlayer.new(:white)
    @black_player = HumanPlayer.new(:black)
    @current_color = :white
  end

  def play
    puts "Welcome to chess!"

    until @board.game_ended_by?(toggle_color(@current_color))


      if @current_color == :white
        turn_of(@white_player)
      else
        turn_of(@black_player)
      end
    end

    game_over
  end

  private

  def toggle_color(color)
    (color == :white) ? :black : :white
  end

  def game_over
    @board.display_board
    winning_color = toggle_color(@current_color)
    if @board.in_check?(@current_color)
      puts "Checkmate! #{ winning_color.to_s.capitalize } Wins!"
    else
      puts "Stalemate."
    end
  end

  def save_game
    save_str = self.to_yaml
    File.open(Operator.save_name,"w") { |f| f.puts(save_str) }
  end

  def load_game
    load_str = File.read(Operator.load_name)
    temp_game = YAML::load(load_str)
    @board = temp_game.board
    @current_color = temp_game.current_color
  end

  def turn_of(player)
    @board.display_board
    puts "Check" if @board.in_check?(@current_color)
    puts "#{ @current_color.to_s.upcase } TURN"

    begin
      move = player.make_move
      process_input(move)
    rescue MoveError => e
      puts e.message
      puts "Please try again."
      @board.display_board
      retry
    end
  end

  def process_input(move)
    case move
    when :save
      save_game
    when :load
      load_game
    when :quit
      abort('Thanks for playing!')
    else
      valid_input_check(move)
      @current_color = toggle_color(@current_color)
      @board.move_and_kill(*move)
    end
  end

  def valid_input_check(move)
    unless move.length == 2
      raise MoveError.new "Improper formatting."
    end
    if @board.what_is_at(move[0]).nil?
      raise MoveError.new "There's no piece there."
    end
    unless @current_color == @board.what_is_at(move[0]).color
      raise MoveError.new "That's not your piece."
    end
    unless @board.legal_move?(*move, @current_color)
      raise MoveError.new "Illegal move."
    end
    if @board.causes_check?(*move, @current_color)
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
    puts "Enter coordinates, of form 'f2,a1', or 'save', 'load', or 'quit'"
    command_parse(gets.chomp)
  end

  private

  def coord_parse(str)
    chars = str.split(//)
    [chars[1].to_i-1, chars[0].ord - 97]
  end

  def command_parse(command) #Does this smell?
    if %w(save load quit exit).include?(command)
      command.to_sym
    else
      command.split(",").map { |str| coord_parse(str) }
    end
  end

end


class Operator

  def self.restart_game?
    puts "Would you like to play again? (y/n)"
    choice = gets.chomp.downcase[0]
    choice == "y" ? true : false
  end

  def self.save_name
    puts "What do you want to name the save file?"
    gets.chomp
  end

  def self.load_name
    puts "What file should I load?"
    gets.chomp
  end
end


class MoveError < RuntimeError
end

if __FILE__ == $PROGRAM_NAME

  loop do
    game = Game.new
    game.play
    break unless Operator.restart_game?
  end
  puts "Thanks for playing!"

end
