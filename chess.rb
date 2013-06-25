# encoding: UTF-8
require './chessboard.rb'
require './chess_pieces.rb'

def parse(str)
  chars = str.split(//)
  [chars[1].to_i-1,chars[0].ord - 97]
end




board = Board.new
board.move_piece(parse("e2"),parse("e4"))
board.display_board
puts
board.move_piece(parse("d1"),parse("h5"))
board.display_board
puts
board.move_piece(parse("f1"),parse("c4"))
board.display_board
puts
board.move_piece(parse("h5"),parse("f7"))
board.display_board
puts

puts board.in_checkmate?(:white)
puts board.in_checkmate?(:black)

# p board.move_piece([6,0], [4,0])
# puts
# puts
# p board.move_piece([7,0],[8,0])
# board.move_piece([6,0], [4,0])
# board.display_board
# board.move_piece([4,0], [3,0])
# board.display_board
# board.move_piece([3,0], [2,0])
# board.display_board
# board.move_piece([2,0], [1,1])
# board.display_board
# board.move_piece([1,1], [2,1])
