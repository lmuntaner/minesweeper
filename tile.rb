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
    # neighbors = get_neighbors
    # bombs = 0
    #
    # neighbors.each do |neighbor|
    #   bombs += 1 if board[neighbor].bomb?
    # end
    #
    # bombs
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
  
  def display
    return 'F' if flagged?
    return '*' unless revealed?
    if bomb?
      'B'
    else
      bombs = count_bombs
      bombs == 0 ? '_' : bombs.to_s
    end
  end
end