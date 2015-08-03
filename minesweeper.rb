require 'byebug'
require 'yaml'
require 'json'
require_relative 'board'

class Minesweeper
  attr_reader :board

  def initialize(size = 9, mine_num = 10)
    @board = Board.new(size,mine_num)
    board.populate_grid
  end

  def take_turn
    act = action
    pos = position

    case act
    when "F"
      board[pos].toggle_flag
    when "R"
      board[pos].reveal
    end

    board.render
  end

  def action
    action = nil

    puts "What action would you like? Reveal or toggle flag? (R/F)"
    until is_valid_action?(action)
      action = gets.chomp.upcase
      error_message unless is_valid_action?(action)
    end

    action
  end

  def position
    position = []

    puts "What position would you like to act on? (row,column)"
    until is_valid_pos?(position)
      position = gets.chomp.split(',').map(&:to_i)
       error_message unless is_valid_pos?(position)
    end

    position
  end

  private
  def is_valid_action?(string)
    ["R","F"].include?(string)
  end

  def is_valid_pos?(array)
    array.length == 2 && array.all? { |coord| coord.between?(0,board.size)}
  end

  def error_message
    puts "Invalid entry -- try again"
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Minesweeper.new
  game.take_turn

end
