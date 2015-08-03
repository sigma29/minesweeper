require 'byebug'
require 'json'
require 'yaml'
require_relative 'tile'

class Board
  attr_reader :size, :num_mines

  def initialize(size = 9,num_mines = 10)
    @size = size
    @num_mines = num_mines
  end

end
