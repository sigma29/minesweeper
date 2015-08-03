require 'byebug'
require 'json'
require 'yaml'
require_relative 'tile'

class Board
  attr_reader :size, :num_bombs, :grid, :mine_pos
  attr_writer :lost

  def initialize(size,num_bombs)
    @size = size
    @num_bombs = num_bombs
    @grid = Array.new(size) { Array.new(size) }
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos,value)
    row,col = pos
    @grid[row][col] = value
  end

  def populate_grid
    grid.each_with_index do |row, row_number|
      row.each_with_index do |tile, col_number|
        pos = [row_number,col_number]
          self[pos] = Tile.new(false,pos,self)
      end
    end

    set_bombs
    self
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0,size - 1) }
  end

  def render
    puts "         #{(0...size).to_a.join(' ')}"
    grid.each_with_index do |row,index|
      puts "Row #{index.to_s.rjust(2)}:  #{row.join(' ')}"
    end
    puts "Enter action S to save, X to exit"
  end

  def set_bombs
    bomb_count = 0
    tiles = grid.flatten.shuffle

    until bomb_count == num_bombs
      tile = tiles.shift
      tile.is_bomb = true
      bomb_count += 1
    end

    self
  end

  def reveal(pos)
    tile = self[pos]

    tile.reveal
    self.lost = true if tile.is_bomb? && tile.revealed?

    if tile.revealed? && tile.neighbors_bomb_count == 0
      tile.neighbors.each do |neighbor|
        self.reveal(neighbor.pos) unless neighbor.revealed? || neighbor.flagged?
      end
    end
  end

  def lost?
    !!@lost
  end


  def won?
    grid.flatten.each do |tile|
      return false if tile.is_bomb? && !tile.flagged?
      return false if tile.flagged? && !tile.is_bomb?
    end

    true
  end

end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  puts "Got here"
  p b.populate_grid
end
