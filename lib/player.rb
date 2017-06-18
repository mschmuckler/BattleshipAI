class HumanPlayer
  attr_reader :name
  def initialize(name="Human")
    @name = name
  end

  def get_play(grid)
    puts "Where to attack?"
    loop do
      coordinates = gets.chomp.split("")
      row = coordinates[0].to_i
      col = coordinates[1].to_i
      break if grid[row][col] == "."
      puts "You've already shot there"
    end
    [row, col]
  end
end

class ComputerPlayer
  attr_reader :name
  def initialize(name="Computer")
    @name = name
  end

  def get_play(grid)
    target_cell = nil
    possible_target = false
    target_found = false
    grid.each do |row|
      row.each do |cell|
        possible_target = true if cell == "X"
      end
    end
    if possible_target == false
      target_cell = random_cell(grid)
    else
      target_cell, target_found = find_target(grid, target_cell)
    end
    target_cell = random_cell(grid) unless target_found
    puts "#{target_cell}"
    target_cell
  end

  def random_cell(grid)
    grid_size = grid.count
    target_cell = nil
    loop do
      target_cell = [rand(0...grid_size), rand(0...grid_size)]
      break if grid[target_cell[0]][target_cell[1]] == "."
    end
    target_cell
  end

  def find_target(grid, target_cell)
    target_found = false
    grid.each_with_index do |row, i1|
      row.each_with_index do |_cell, i2|
        if grid[i1][i2] == "X"
          target_cell = [i1, i2]
          adjacent_x_exist, direction = adjacent_X?(grid, target_cell)
          if adjacent_x_exist
            target_cell, target_found = find_adjacent_target(grid, target_cell, direction)
            break if target_found
          else
            target_cell, target_found = find_nearby_target(grid, target_cell)
            break if target_found
          end
        end
      end
      break if target_found
    end
    return target_cell, target_found
  end

  def adjacent_X?(grid, target_cell)
    if cell_above_valid?(grid, target_cell, "X")
      return true, :vertical
    elsif cell_below_valid?(grid, target_cell, "X")
      return true, :vertical
    elsif cell_left_valid?(grid, target_cell, "X")
      return true, :horizontal
    elsif cell_right_valid?(grid, target_cell, "X")
      return true, :horizontal
    else
      return false, :both
    end
  end

  def find_adjacent_target(grid, target_cell, direction)
    target_found = false
    if direction == :vertical
      if cell_above_valid?(grid, target_cell)
        target_cell[0] -= 1
        target_found = true
      elsif cell_below_valid?(grid, target_cell)
        target_cell[0] += 1
        target_found = true
      end
    elsif direction == :horizontal
      if cell_left_valid?(grid, target_cell)
        target_cell[1] -= 1
        target_found = true
      elsif cell_right_valid?(grid, target_cell)
        target_cell[1] += 1
        target_found = true
      end
    end
    return target_cell, target_found
  end

  def find_nearby_target(grid, target_cell)
    target_found = false
    if cell_above_valid?(grid, target_cell)
      target_cell[0] -= 1
      target_found = true
    elsif cell_below_valid?(grid, target_cell)
      target_cell[0] += 1
      target_found = true
    elsif cell_left_valid?(grid, target_cell)
      target_cell[1] -= 1
      target_found = true
    elsif cell_right_valid?(grid, target_cell)
      target_cell[1] += 1
      target_found = true
    end
    return target_cell, target_found
  end

  def cell_above_valid?(grid, target_cell, target_value=".")
    (target_cell[0] - 1) >= 0 && grid[target_cell[0] - 1][target_cell[1]] == target_value
  end

  def cell_below_valid?(grid, target_cell, target_value=".")
    (target_cell[0] + 1) < grid.count && grid[target_cell[0] + 1][target_cell[1]] == target_value
  end

  def cell_left_valid?(grid, target_cell, target_value=".")
    (target_cell[1] - 1) >= 0 && grid[target_cell[0]][target_cell[1] - 1] == target_value
  end

  def cell_right_valid?(grid, target_cell, target_value=".")
    (target_cell[1] + 1) < grid.count && grid[target_cell[0]][target_cell[1] + 1] == target_value
  end
end
