require_relative "board"
require_relative "player"

class BattleshipGame
  attr_reader :player1, :player2, :board1, :board2, :current_player
  def initialize(player1, player2, board1, board2)
    @player1 = player1
    @player2 = player2
    @board1 = board1
    @board2 = board2
    @hidden_grid1 = Array.new(board1.grid_size) { Array.new(board1.grid_size, ".") }
    @hidden_grid2 = Array.new(board2.grid_size) { Array.new(board2.grid_size, ".") }
    @current_player = 1
    @current_board = 1
    @current_grid = 1
    @turn_count = 1
  end

  def main_play
    setup_boards
    until game_over?
      puts "Turn \##{@turn_count}"
      play_turn
      switch_players
      puts "\n\n"
      @turn_count += 1 if @current_player == 1
    end
    switch_players
    puts "#{current_player.name} wins!"
  end

  def play_turn
    puts "#{current_player.name}'s turn"
    display_hidden_grid
    position = current_player.get_play(current_grid)
    attack(position)
  end

  def attack(position)
    if current_board.empty?(position)
      self[position] = "O"
      puts "#{current_player.name} missed"
    else
      ship = ship_hit(position)
      self[position] = "X"
      current_board[position] = :x
      ship.life -= 1
      puts "#{current_player.name} hits"
      puts "#{other_player.name}'s #{ship.name} has been sunk" if ship.sunk?
    end
  end

  def ship_hit(position)
    ship_hit = "to be determined"
    current_board.all_ships.each do |ship|
      if ship.size == current_board[position]
        ship_hit = ship
        break
      end
    end
    ship_hit
  end

  def game_over?
    return true if @board1.all_ships.all? { |ship| ship.sunk? }
    return true if @board2.all_ships.all? { |ship| ship.sunk? }
    false
  end

  def setup_boards
    @board1.setup_random
    @board2.setup_random
  end

  def display_hidden_grid
    current_grid.each_with_index do |row, index|
      print "#{index}|| "
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
    print "    "
    for _cell in 0...current_grid.count
      print "= "
    end
    puts ""
    print "    "
    for i in 0...current_grid.count
      print "#{i} "
    end
    puts ""
  end

  def current_player
    return @player1 if @current_player == 1
    return @player2 if @current_player == 2
  end

  def current_board
    return @board1 if @current_player == 1
    return @board2 if @current_player == 2
  end

  def current_grid
    return @hidden_grid1 if @current_player == 1
    return @hidden_grid2 if @current_player == 2
  end

  def other_player
    return @player2 if @current_player == 1
    return @player1 if @current_player == 2
  end

  def switch_players
    if @current_player == 1
      @current_player = 2
    else
      @current_player = 1
    end
  end

  def []=(position, value)
    row, col = position
    current_grid[row][col] = value
  end
end

if $PROGRAM_NAME == __FILE__
  game1 = BattleshipGame.new(ComputerPlayer.new("Picard"),
                             ComputerPlayer.new("Riker"),
                             Board.new,
                             Board.new)
  game1.main_play
end
