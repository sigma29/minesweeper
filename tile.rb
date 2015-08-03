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

  attr_reader :is_bomb, :pos, :board, :bomb_count
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

  def revealed?
    @revealed
  end

  def flagged?
    @flagged
  end

  def neighbors
    neighbors = []
    row, col = pos
    NEIGHBORS_REL.each do |delta|
      x_diff, y_diff = delta
      new_pos = [row + x_diff, col + y_diff]
      next unless new_pos.all? { |coord| coord.between?(0, board.size - 1) }
      neighbors << board[new_pos]
    end

    neighbors
  end

  def neighbors_bomb_count
    @bomb_count = neighbors.count { |neighbor| neighbor.is_bomb? }
    bomb_count
  end

  def reveal
    return if flagged?
    self.revealed = true

    if neighbors_bomb_count == 0
      neighbors.each { |neighbor| neighbor.reveal unless neighbor.revealed? || neighbor.flagged? }
    end
  end

  def toggle_flag
    return if revealed?
    self.flagged = self.flagged? ? false : true
  end

  def to_s
    if flagged?
      "F"
    elsif !revealed?
      "*"
    elsif revealed? && bomb_count == 0
      "_"
    else
      "#{bomb_count}"
    end
  end

  def inspect
    "Position:#{pos} is_bomb: #{is_bomb} Flagged: #{flagged} Revealed: #{revealed}"
  end
end
