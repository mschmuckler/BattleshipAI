require_relative "ship"

class Board
  attr_accessor :grid, :carrier, :battleship, :submarine, :destroyer, :all_ships
  attr_reader :grid_size
  def initialize(grid=Board.default_grid)
    @grid = grid
    @grid_size = grid.count
    @carrier, @battleship, @submarine, @destroyer = Ship.create_all_ships
    @all_ships = [@carrier, @battleship, @submarine, @destroyer]
  end

  def self.default_grid
    Array.new(10) { Array.new(10) }
  end

  def empty?(position="entire_grid")
    if position == "entire_grid"
      @grid.each { |row| row.each { |cell| return false if cell == :s }}
      true
    elsif (position[0] >= @grid_size ||
           position[1] >= @grid_size ||
           position[0] < 0 ||
           position[1] < 0)
      false
    else
      self[position].nil?
    end
  end

  def setup_random
    @all_ships.each do |ship|
      possible_placement = false
      until possible_placement
        possible_placement = true
        random_cell = [rand(0...@grid_size), rand(0...@grid_size)]
        direction1, direction2 = [0,1].sample, [-1,1].sample
        for _cell in 0...ship.size
          possible_placement = false unless empty?(random_cell)
          random_cell[direction1] += direction2
        end
      end
      for _cell in 0...ship.size
        random_cell[direction1] -= direction2
        self[random_cell] = ship.size
      end
    end
  end

  def display_revealed_grid
    @grid.each do |row|
      row.each do |cell|
        if cell.nil?
          print "."
        else
          print cell
        end
        print " "
      end
      puts ""
    end
  end

  def [](position)
    row, col = position
    @grid[row][col]
  end

  def []=(position, value)
    row, col = position
    @grid[row][col] = value
  end
end
