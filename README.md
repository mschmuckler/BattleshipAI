# BattleshipGame

The game Battleship created for the terminal in Ruby.

It is played with two players, either of which may be Human or Computer controlled:
  - The ComputerPlayer has a near optimized AI (assuming it is unknown when a ship has been sunk).
  - There are four ships by default (sizes 5, 4, 3, & 2) and they are placed randomly on a board with no overlap.
  - The 'Board.display_revealed_grid' method can be used to see where the ships are.

Download the lib directory and run 'ruby battleship.rb' to play. By default there are two ComputerPlayers playing each other, feel free to switch one or both to a HumanPlayer.
