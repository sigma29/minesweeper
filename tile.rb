require 'byebug'
require 'json'
require 'yaml'
require 'colorize'

class Tile
  NEIGHBORS_REL = [
    [-1, -1],
    [-1,  0],
    [-1,  1],
    [ 0, -1],
    [ 0,  1],
    [ 1, -1],
    [ 1,  0],
    [ 1,  1]
  ]

  attr_reader  :pos, :board, :bomb_count
  attr_accessor :flagged, :revealed, :is_bomb

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
      next unless board.on_board?(new_pos)
      neighbors << board[new_pos]
    end

    neighbors
  end

  def neighbors_bomb_count
    @bomb_count = neighbors.count { |neighbor| neighbor.is_bomb? }
    bomb_count
  end

  def reveal
    return if flagged? || revealed?
    self.revealed = true

    self
  end

  def toggle_flag
    return if revealed?
    self.flagged = self.flagged? ? false : true

    nil
  end

  def to_s
    if flagged?
      "\u2691".encode('utf-8').colorize(:red)
    elsif !revealed?
      "*"
    elsif revealed? && is_bomb?
      "\u2620".encode('utf-8')
    elsif revealed? && bomb_count == 0
      "_"
    else
      case bomb_count
      when 1
        "#{bomb_count}".colorize(:light_cyan)
      when 2
        "#{bomb_count}".colorize(:green)
      when 3
        "#{bomb_count}".colorize(:light_red)
      when 4
        "#{bomb_count}".colorize(:blue)
      when 5
        "#{bomb_count}".colorize(:red)
      when 6
        "#{bomb_count}".colorize(:cyan)
      when 7
        "#{bomb_count}".colorize(:black)
      when 8
        "#{bomb_count}".colorize(:light_black)
      end
    end
  end

  def inspect
    "Position:#{pos} is_bomb: #{is_bomb} Flagged: #{flagged} Revealed: #{revealed}"
  end
end
