require 'io/console'

class Mineboard
    attr_accessor :grid, :num_bombs, :pointer_pos
  
  def initialize(rows = 9, cols = 9, num_bombs = 9)
    @grid = Array.new(rows) { Array.new(cols) }
    @num_bombs = num_bombs
    @total_tiles = rows * cols
    @pointer_pos = [0, 0]
    generate_tiles
  end
  
  def [](pos)
    grid[pos[0]][pos[1]]
  end
  
  def generate_tiles
    bomb_pos = generate_bomb_pos
    
    @grid.each_with_index do |row, idx_row|
      row.count.times do |idx_col|
        bomb = bomb_pos.include?([idx_row, idx_col]) ? true : false
        tile = Tile.new([idx_row, idx_col], self, bomb)
        @grid[idx_row][idx_col] = tile
      end
    end
  end
  
  def revealed_count
    @grid.flatten.count &:revealed?
  end
  
  def flag_count
    @grid.flatten.count &:flagged?
  end
  
  def generate_bomb_pos
    bomb_pos = []
    
    until bomb_pos.count == num_bombs
      random_pos = [rand(9), rand(9)]
      bomb_pos << random_pos unless bomb_pos.include?(random_pos)
    end
    bomb_pos
  end
  
  def reveal(position)
    self[position].reveal
  end
  
  def flag(position)
    self[position].toggle_flag
  end
  
  def reveal_all
    grid.count.times do |row|
      grid[0].count.times do |col|
        position = [row, col]
        self[position].reveal
      end
    end
  end
  
  def flag_message
    puts "You have flagged #{flag_count} tiles."
    puts "You have #{num_bombs - flag_count} tiles left to flag."
  end
  
  def move_cursor
    input = STDIN.getch
    p input
    case input
    when "a"
      @pointer_pos[1] -= 1
    when "d"
      @pointer_pos[1] += 1
    when "s"
      @pointer_pos[0] += 1
    when "w"
      @pointer_pos[0] -= 1
    when "f"
      flag(pointer_pos)
    when "r"
      reveal(pointer_pos)
    end
  end
  
  def display
    system("clear")
    puts "   #{(0..8).to_a.join("  ")}"
    @grid.each_with_index do |row, index|
      row_array = ["#{index} "]
      row.each do |tile|
        row_array << tile.display(@pointer_pos)
      end
      puts row_array.join('')
    end
  end
  
  def won?
    revealed_count == (@total_tiles - num_bombs) &&
    num_bombs == flag_count
  end
  
  def lost?
    @grid.flatten.any? { |tile| tile.revealed? && tile.bomb? }
  end
end
