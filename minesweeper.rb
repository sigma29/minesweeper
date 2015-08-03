require 'byebug'
require 'yaml'
require 'json'
require_relative 'board'

class Minesweeper
  def self.start_up
    input = ""
    puts "Are you loading an old game file (Y/N)"
    until self.is_valid_choice?(input)
      input = gets.chomp.upcase
      puts "Please choose Y or N" unless self.is_valid_choice?(input)
    end

    case input
    when "Y"
      self.load
    when "N"
      Minesweeper.new(9,10).play
    end
  end

  def self.load
    puts "What local file would you like to load? "
    filename = gets.chomp
    contents = File.read(filename)
    saved_game = YAML.load(contents)
    saved_game.play
  end

  def self.is_valid_choice?(choice)
    ["Y","N"].include?(choice)
  end

  attr_reader :board

  def initialize(size = 9, bomb_num = 10)
    @board = Board.new(size,bomb_num).populate_grid
  end

  def save
    puts "What would you like to name your file (Ex:game1.txt) ?"
    filename = gets.chomp
    File.open(filename,"w") do |file|
      file.puts self.to_yaml
    end
  end


  def play
    board.render

    until board.won?
      take_turn
      break if board.lost?
    end

    puts board.won? ? "You are Awesome!!" : "Too bad!"
  end

  def take_turn
    act = self.action

    save if act == "S"
    Process.exit!(true) if act == "X"
    pos = self.position

    case act
    when "F"
      board[pos].toggle_flag
    when "R"
      board.reveal(pos)
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
    ["R","F","S","X"].include?(string)
  end

  def is_valid_pos?(array)
    array.length == 2  && board.on_board?(array)
  end

  def error_message
    puts "Invalid entry -- try again"
  end

end

if __FILE__ == $PROGRAM_NAME
  Minesweeper.start_up

end
