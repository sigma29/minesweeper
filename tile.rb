require 'byebug'
require 'json'
require 'yaml'

class Tile
  NEIGHBORS_REL = [
    [-1, -1],
    [-1,  0],
    [-1,  1],
    [0,  -1],
    [0,   1],
    [1,  -1],
    [1,   0],
    [1,   1]
  ]

  attr_reader :is_bomb, :pos, :board
  attr_accessor :flagged, :revealed

  def initialize(is_bomb, pos, board)
    @is_bomb = is_bomb
    @pos = pos
    @board = board
    @flagged = false
    @revealed = false
  end

  def is_bomb?
    @is_bomb
  end

  def neighbors
    neighbors = []
    row, col = pos

    NEIGHBORS_REL.each do |delta|
      next unless delta.all? { |coord| coord.between?(0, board.size - 1) }
      x_diff, y_diff = delta
      neighbors << board[[row + x_diff, col + y_diff]]
    end

    neighbors
end
