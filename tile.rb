require 'byebug'
require 'json'
require 'yaml'

class Tile
  attr_reader :is_bomb, :pos, :board
  attr_accessor :flagged, :revealed

  def initialize(is_bomb, pos, board)
    @is_bomb = is_bomb
    @pos = pos
    @board = board
    @flagged = false
    @revealed = false
  end
end
