require './tile'
require './mineboard'
require 'yaml'

class Minesweeper
  attr_accessor :board, :total_tiles, :num_bombs
  
  def initialize(rows = 9, cols = 9, num_bombs = 9)
    @rows = rows
    @cols = cols
    @total_tiles = rows * cols
    @num_bombs = num_bombs
    @board = Mineboard.new(@rows, @cols, @num_bombs)
  end
  
  def self.load(filename = "Minesweeper")
    # yaml_string = File.read(filename)
    YAML::load_file(filename)
  end
  
  def run
    until @board.won? || @board.lost?
      board.display
      board.move_cursor
    end
    
    display_end
  end
  
  def save(filename)
    File.open(filename, "w") do |f|
      f.puts self.to_yaml
    end
  end
  
  def save_request 
    print "Do you want to save the game (y/n)? "
    if gets.chomp.downcase == "y"
      print "Enter the filename: "
      save(gets.chomp)
    end
  end

  def display_end
    won_text = 'Congratulations!! You won!!'
    lost_text = 'You stepped on a bomb!! Game over.'
    text = @board.won? ? won_text : lost_text
    board.reveal_all
    board.display
    puts text
  end
  
  def ask_flag
    print "1 for flag, 2 for reveal? "
    gets.chomp.to_i
  end
  
  def ask_position
    print "What row? "
    row = gets.chomp.to_i
    print "What column? "
    col = gets.chomp.to_i
    
    [row, col]
  end
end

if __FILE__ == $PROGRAM_NAME
  print "Would you like to load a game (y/n) "
  if gets.chomp.downcase == 'y'
    print "Enter filename: "
    filename = gets.chomp
    old_game = Minesweeper.load(filename)
    old_game.run
  else
    game = Minesweeper.new(9, 9, 5)
    game.run
  end
end
      




