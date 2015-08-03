require 'byebug'
require 'json'
require 'yaml'
require_relative 'tile'

class Board
  attr_reader :size, :num_mines, :grid

  def initialize(size = 9,num_mines = 10)
    @size = size
    @num_mines = num_mines
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
    mine_pos = set_mine_pos

    grid.each_with_index do |row, row_number|
      row.each_with_index do |tile, col_number|
        pos = [row_number,col_number]
        if mine_pos.include?(pos)
          self[pos] = Tile.new(true,pos,self)
        else
          self[pos] = Tile.new(false,pos,self)
        end
      end
    end

  end

  def set_mine_pos
    mine_pos =[]

    until mine_pos.count == num_mines
      row = rand(size)
      col = rand(size)
      mine_pos << [row,col] unless mine_pos.include?([row,col])
    end

    mine_pos
  end

end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  puts "Got here"
  p b.populate_grid
end
