require 'colorize'

class Tile
  attr_accessor :position
  attr_reader :board
  
  SURROUNDINGS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], 
                  [0, 1], [1, -1], [1, 0], [1, 1]]
  
  def initialize(position, board, bomb = false)
    @position = position
    @bomb = bomb
    @flagged = false
    @revealed = false
    @board = board
  end
  
  def flagged?
    @flagged
  end
  
  def bomb?
    @bomb
  end
  
  def revealed?
    @revealed
  end
  
  def toggle_flag
    @flagged = !@flagged
  end
  
  def count_bombs
    neighbors.count{ |neighbor| neighbor.bomb? }
  end
  
  def neighbors
    rows = board.grid[0].count
    cols = board.grid.count
    
    neighbor_tiles = []
    SURROUNDINGS.each do |neighbor|
      new_position = [(neighbor[0] + position[0]), (neighbor[1] + position[1])]
      next unless (0...rows).include? new_position[0]
      next unless (0...cols).include? new_position[1]
      neighbor_tiles << board[new_position]
    end
    
    neighbor_tiles
  end
  
  def reveal
    return true if flagged?
    @revealed = true
    return false if bomb?
    if count_bombs == 0
      neighbors.each do |neighbor|
        neighbor.reveal unless neighbor.revealed?
      end
    end
    true
  end
  
  def display_tile(str)
    case str
    when 'F'
      ' F '.colorize(:red)
    when '*'
      color = position.inject(&:+).even? ? :light_black : :black
      '   '.colorize( :background => color)        
    when 'B'
      ' * '.colorize( :background => :red)
    when '_'
      '   '.colorize( :background => :light_blue)
    else
      " #{str} ".colorize( :background => :light_blue)
    end
  end
  
  def display
    return display_tile('F') if flagged?
    return display_tile('*') unless revealed?
    if bomb?
      display_tile('B')
    else
      bombs = count_bombs
      bombs == 0 ? display_tile('_') : display_tile(bombs.to_s)
    end
  end
end