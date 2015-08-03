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

end
