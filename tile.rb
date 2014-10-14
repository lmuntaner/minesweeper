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
  
  def display_tile(str, pointer)
    background = pointer ? :white : nil
    case str
    when 'F'
      background ||= :blue
      ' F '.colorize(:color => :red, :background => background)
    when '*'
      background ||= position.inject(&:+).even? ? :light_black : :black
      '   '.colorize( :background => background)        
    when 'B'
      background ||= :red
      ' * '.colorize( :background => background)
    when '_'
      background ||= :light_white
      '   '.colorize( :background => background)
    else
      background ||= :light_white
      " #{str} ".colorize( :background => background)
    end
  end
  
  def display(pointer_pos)
    cursor = (pointer_pos == position)
    return display_tile('F', cursor) if flagged?
    return display_tile('*', cursor) unless revealed?
    if bomb?
      display_tile('B', cursor)
    else
      bombs = count_bombs
      bombs == 0 ? display_tile('_', cursor) : display_tile(bombs.to_s, cursor)
    end
  end
end